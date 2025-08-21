import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [ "darkThemeButton" ]

  connect() {
    this.toggleLink()

    const htmlTag = document.documentElement
    this.observer = new MutationObserver(() => this.toggleLink())
    this.observer.observe(htmlTag, { attributes: true })
  }

  disconnect() {
    if (this.observer) this.observer.disconnect()
  }

  toggleLink() {
    const htmlTag = document.documentElement
    const darkReaderEnabled = htmlTag.hasAttribute("data-darkreader-mode")

    if (darkReaderEnabled) {
      this.darkThemeButtonTarget.classList.add("hidden")
    } else {
      this.darkThemeButtonTarget.classList.remove("hidden")
    }
  }
}
