import { Controller } from "@hotwired/stimulus"
import 'flowbite';

// Connects to data-controller="place"
export default class extends Controller {
  // tooltips: Every geographic source has an icon which loads a tooltip. The content is in div below the icon
  static targets = ["tooltip", "accordion", "status"]

  initialize() {
    this.STATUS_CLASSMAP = {
      "": ["", ""],
      "ACTIVE": ["bg-green-100","text-green-800"],
      "GONE": ["bg-red-100", "text-red-800"],
      "DAMAGED": ["bg-yellow-100", "text-yellow-800"]
    }
    this.PUBL_STATUS_CLASSMAP = {
      "ACCEPTED": ["bg-green-100","text-green-800"],
      "IN_REVIEW": ["bg-yellow-100", "text-yellow-800"],
      "REJECTED": ["bg-red-100", "text-red-800"]
    }
  }

  connect() {
    this.setStatusBadge()
    this.setPublishedStatusBadge()
    this.setSourcesAccordion()
    this.setSourcesTooltips()
  }
  
  setStatusBadge() {
    const statusContent = document.getElementById("tooltip-place-status")
    const statusTarget = document.getElementById("place-status")
    
    var classes = this.STATUS_CLASSMAP[statusTarget.dataset.status]
    statusTarget.classList.add(classes[0])
    statusTarget.classList.add(classes[1])
    
    new Tooltip(statusContent, statusTarget, { placement: 'bottom', triggerType: 'hover'}, {})
  }

  setPublishedStatusBadge() {
    const statusContent = document.getElementById("tooltip-place-published-status")
    const statusTarget = document.getElementById("place-published-status")
    
    var classes = this.PUBL_STATUS_CLASSMAP[statusTarget.dataset.status]
    statusTarget.classList.add(classes[0])
    statusTarget.classList.add(classes[1])
    
    new Tooltip(statusContent, statusTarget, { placement: 'bottom', triggerType: 'hover'}, {})
  }

  setSourcesAccordion() {
    const sourceAccordion = document.getElementById("sources-accordion")
    this.accordionTargets.forEach((target) => {
      const content = [{
        id: `source-${target.dataset.sourceId}`,
        targetEl: document.getElementById(`source-content-${target.dataset.sourceId}`),
        triggerEl: target,
        active: true,
      }]
      let options = {
        alwaysOpen: false,
      }
      new Accordion(sourceAccordion, content, options, {});
    })
  }

  setSourcesTooltips() {
    // All available source tooltips are created on start
    this.tooltipTargets.forEach((target) => {
      const content = document.getElementById(`tooltip-source-content-${target.dataset.sourceId}`)
      new Tooltip(content,target, { placement: 'top', triggerType: 'hover'}, {})
    })
  }
}
