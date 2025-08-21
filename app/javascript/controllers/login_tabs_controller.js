import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "tab", "forms" ]

  switchTab(event) {
    const activeTab = event.currentTarget

    this.setAllInactive()
    this.setActive(activeTab)
  }

  setActive(activeTab) {
    const tabType = activeTab.dataset.tab
    activeTab.classList.add("active")

    const activeForm = this.element.querySelector(`.${tabType}-form`)
    activeForm.classList.add("active")

    this.formsTarget.classList.add(`${tabType}-tab`)
  }

  setAllInactive() {
    this.tabTargets.forEach(tab => {
      tab.classList.remove("active")
    })

    this.element.querySelectorAll('.form').forEach(form => {
      form.classList.remove("active")
    })

    this.formsTarget.classList.remove("sign-up-tab", "sign-in-tab", "quick-login-tab")
  }
}
