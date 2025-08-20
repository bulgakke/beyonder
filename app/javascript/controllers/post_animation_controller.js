import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    requestAnimationFrame(() => {
      this.element.classList.add("show")
    })

    setTimeout(() => {
      this.element.classList.remove("new-post")
    }, 2500)
  }
}
