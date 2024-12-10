import { Controller } from "@hotwired/stimulus"
import 'flowbite';

// Connects to data-controller="place"
export default class extends Controller {
  // tooltips: Every geographic source has an icon which loads a tooltip. The content is in div below the icon
  static targets = ["tooltip", "accordion"]

  connect() {
    // All available tooltips are created on start
    this.tooltipTargets.forEach((target) => {
      const content = document.getElementById(`tooltip-source-content-${target.dataset.sourceId}`)
      new Tooltip(content,target, { placement: 'top', triggerType: 'hover'}, {})
    })

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
  
}
