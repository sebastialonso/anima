# Pin npm packages by running ./bin/importmap

pin "application"
pin "leaflet" # @1.9.4
pin "leaflet-providers" # @2.0.0
pin "sidebar", to: "https://cdn.jsdelivr.net/npm/leaflet-sidebar@0.2.4/src/L.Control.Sidebar.min.js"
pin "easyButton", to: "https://cdn.jsdelivr.net/npm/leaflet-easybutton@2/src/easy-button.js"
pin "flowbite", to: "https://cdn.jsdelivr.net/npm/flowbite@2.5.2/dist/flowbite.turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

## TODO consider using Pannellum https://pannellum.org/documentation/examples/initial-view/