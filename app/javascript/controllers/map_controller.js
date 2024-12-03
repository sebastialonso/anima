import { Controller } from "@hotwired/stimulus"
import L from "leaflet"

// Connects to data-controller="map"
export default class extends Controller {
  static targets = ["container", "select", "statsCardinality", "statsSources", "statsWithInstagram"]
  // static values =  { filterSlug: String }

  initialize() {
    this.selectTarget.selectedIndex = 0;
  }

  async connect() {
    this.places = await this.fetchPlaces();
    this.redIcon = new L.Icon({
      iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-red.png',
      shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
      iconSize: [25, 41],
      iconAnchor: [12, 41],
      popupAnchor: [1, -34],
      shadowSize: [41, 41]
    });
    this.yellowIcon = new L.Icon({
      iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-yellow.png',
      shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
      iconSize: [25, 41],
      iconAnchor: [12, 41],
      popupAnchor: [1, -34],
      shadowSize: [41, 41]
    });

    this.createMap()
    this.map.setView([-34.223136, -70.980517], 12);
  }

  // Called before map is rendered
  async fetchPlaces() {
    const meta = document.querySelector('meta[name=csrf-token]');
    const token = meta && meta.getAttribute('content');
    
    let places = await fetch("/data.json", {
      headers: {'X-CSRF-Token': token ?? false, "Content-Type": "application/json"},
    })
      .then((response) => response.json())
      .then((response) => {
        console.info(response[0])
        return response;
      })
      return places;
  }

  createMap() {
    this.map = L.map(this.containerTarget)
    const baseProvider = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
    const cartoProvider = 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png'
    
    L.tileLayer(cartoProvider, {
      maxZoom: 19,
      attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    }).addTo(this.map);

    // Define all sidebars and register them
    var sidebarMenu1 = L.control.sidebar('sidebar-menu-1', {
      position: 'left',
      autoPan: false,
    });
    var sidebarMenu2 = L.control.sidebar('sidebar-menu-2', {
      position: 'left',
      autoPan: false,
    });
    var sidebars = [sidebarMenu1, sidebarMenu2];

    // Hide all sidebars when clicking the map
    this.map.on('click', function () {
      sidebars.forEach((bar) => {
        bar.hide();
      })
    })
    sidebars.forEach((bar) => {
      this.map.addControl(bar);
    })

    // Add menu buttons & sidebar
    // Button menu 1
    L.easyButton('fa-filter', function(btn, map){
      sidebars.forEach((bar) => {
        bar.hide();
      })
      sidebarMenu1.toggle();
    }).addTo(this.map);

    // Add markers
    let markers = this.buildMarkers(this.places);
  
    // setup a marker group and add markers to it
    this.mainMarkerLayer = L.layerGroup(markers).addTo(this.map);
    this.currentLayer = this.mainMarkerLayer;

    let stats = this.computeStats(this.places);
    console.info({stats})
    this.statsCardinalityTarget.innerText = stats.cardinality;
    this.statsSourcesTarget.innerText = stats.moreThanSingleSource;
    this.statsWithInstagramTarget.innerText = stats.withInstragramSource;
  }

  filterByCounty(event) {
    console.log(event.target.value);
    let filterSlug = event.target.value;    
    this.map.removeLayer(this.currentLayer);

    var filtered;

    if (filterSlug == "ALL") {
      filtered = this.places;
      this.currentLayer = this.mainMarkerLayer;
    } else {
      filtered = this.places.filter((pos) => {
        return pos.place.code.startsWith(filterSlug)
      });
      this.currentLayer = L.layerGroup(this.buildMarkers(filtered));
    }

    // compute stats and paint them
    let stats = this.computeStats(filtered);
    this.statsCardinalityTarget.innerText = stats.cardinality;
    this.statsSourcesTarget.innerText = stats.moreThanSingleSource;
    this.statsWithInstagramTarget.innerText = stats.withInstragramSource;

    // Set built marker layer
    this.currentLayer.addTo(this.map);
    // Move map to first marker position
    this.map.setView(filtered[0].place.to_latlon, 13);
  }

  // Utility functions
  buildMarkers(data) {
    return data.map((pos) => {
      let place = pos.place;
      const [latitude, longitude] = place.to_latlon
      if (place.published_status == "IN_REVIEW") {
        var marker = L.marker([latitude, longitude], {icon: this.redIcon}).on('click', function () {
          window.open(`http://localhost:3000/animitas/${pos.place.code}`); // abre URL en otra pestaña
        })
      } else {
        var marker = L.marker([latitude, longitude]).on('click', function () {
          window.open(`http://localhost:3000/animitas/${pos.place.code}`); // abre URL en otra pestaña
        })
      }
      return marker
    })
  }

  computeStats(data) {
    let base = {
      moreThanSingleSource: 0,
      cardinality: 0,
      withInstragramSource: 0,
    }

    data.forEach((p) => {
      base.cardinality++  
      if (p.place.sources > 1) { base.moreThanSingleSource++ }
      if (p.place.has_instagram_source) { base.withInstragramSource++ }
    })
    return base
  }

  disconnect() {
    this.map.remove();
  }
}
