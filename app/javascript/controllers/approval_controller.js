import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="approval"
export default class extends Controller {
  static targets = ["button"]
  static values = { code: String, id: String }

  connect() {
  }

  disconnect(){
  }

  async approve() {
    const meta = document.querySelector('meta[name=csrf-token]');
    const token = meta && meta.getAttribute('content');
    
    fetch(`/animitas/${this.codeValue}/approve.json`, {
      headers: {'X-CSRF-Token': token ?? false, "Content-Type": "application/json"},
      method: "PATCH",
    }).then((res) => res.json())
      .then((res) => {
      console.info(res)
      if (res.success) {
        document.getElementById(`place-card-${this.idValue}`).remove()
      }
    })
  }

  reject() {
    const meta = document.querySelector('meta[name=csrf-token]');
    const token = meta && meta.getAttribute('content');

    fetch(`/animitas/${this.codeValue}/reject.json`, {
      headers: {'X-CSRF-Token': token ?? false, "Content-Type": "application/json"},
      method: "PATCH",
    }).then((res) => res.json())
      .then((res) => {
      console.info(res)
      if (res.success) {
        document.getElementById(`place-card-${this.idValue}`).remove()
      }
    })
  }
}
