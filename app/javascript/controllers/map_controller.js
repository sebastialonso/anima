import { Controller } from "@hotwired/stimulus"
import L from "leaflet"

// Connects to data-controller="map"
export default class extends Controller {
  static targets = ["container", "select", "statsCardinality", "statsSources", "statsWithInstagram"]
  static values =  { placeUrl: String }

  initialize() {
    this.selectTarget.selectedIndex = 0;
    this.defaultZoom = 14;
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
    console.info(this.placeUrlValue)
    this.map.setView([-33.44346588396287, -70.65378058448157], this.defaultZoom);
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
    var sidebars = [sidebarMenu1];

    // Hide all sidebars when clicking the map
    this.map.on('click', function () {
      sidebars.forEach((bar) => {
        bar.hide();
      })
    })
    sidebars.forEach((bar) => {
      this.map.addControl(bar);
    })

    var drawNearLocations = this.drawNearLocations
    // Add menu buttons & sidebar
    var buttonsBar = []
    let filterButton = L.easyButton('fa-filter', function(btn, map){
      sidebars.forEach((bar) => {
        bar.hide();
      })
      sidebarMenu1.toggle();
    }, 'Filtra por comunas')
    document.getElementById("sidebar-menu-1").classList.remove("hidden");
    buttonsBar.push(filterButton);

    let findYouButton = L.easyButton('fa-crosshairs', function(btn, map){
      drawNearLocations(map);
      sidebars.forEach((bar) => {
        bar.hide();
      })
    }, 'Encuentra cercanos a tu ubicación')
    buttonsBar.push(findYouButton);

    var editBar = L.easyBar(buttonsBar);
    editBar.addTo(this.map);

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
    this.map.setView(filtered[0].place.to_latlon, this.defaultZoom);
  }

  drawNearLocations(map) {
    var defaultRadius = 100;
    var midRadius = 250;
    var longRadius = 500;
    
    map.locate({setView : true, maxZoom: 14})
    .on('locationfound', function(e) {
        L.circle(e.latlng, longRadius, { stroke: false, color: '#386ef7', fillOpacity: 0.2}).addTo(map);
        L.circle(e.latlng, midRadius, { stroke: false, color: '#ac2bf2', fillOpacity: 0.3}).addTo(map);
        L.circle(e.latlng, defaultRadius, { stroke: false, color: '#f42929', fillOpacity: 0.4}).addTo(map);
        //small.bindTooltip(`${small.getRadius()}`, {offset: [small.getRadius()/14, small.getRadius()/14], direction: 'center', permanent: true}).addTo(map);
        
     })
    .on('locationerror', function(e){
      console.log(e);
      alert("Location access denied.");
    });
    return "HI"
  }

  // Utility functions
  buildMarkers(data) {
    let URLRegex = /^(.+animitas\/)/g;
    const matches = this.placeUrlValue.match(URLRegex);
    console.info(matches[0])
    const placeURL = matches[0]

    return data.map((pos) => {
      let place = pos.place;
      const [latitude, longitude] = place.to_latlon
      if (place.published_status == "IN_REVIEW") {
        var marker = L.marker([latitude, longitude], {icon: this.redIcon}).on('click', function () {
          window.open(`${placeURL}${pos.place.code}`); // abre URL en otra pestaña
        })
      } else {
        var marker = L.marker([latitude, longitude]).on('click', function () {
          window.open(`${placeURL}${pos.place.code}`); // abre URL en otra pestaña
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
