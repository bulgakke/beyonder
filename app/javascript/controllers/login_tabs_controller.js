import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "tab", "forms" ]
  static values = { activeTab: String }

  connect() {
    if (!["sign-up", "quick-login"].includes(this.activeTabValue)) {
      // nothing to do, the default state ("sign-in") is set in the sessions/new view
      return
    }

    // otherwise the value was passed in the query parameter, set active tab
    const activeTab = this.tabTargets.find(tab => tab.dataset.tab === this.activeTabValue)

    this.setAllInactive()
    this.setActive(activeTab)
  }

  switchTab(event) {
    const activeTab = event.currentTarget

    this.setAllInactive()
    this.setActive(activeTab)
  }

  setActive(activeTab) {
    const tabType = activeTab.dataset.tab
    activeTab.classList.add("active")

    const activeForm = this.element.querySelector(`.${tabType}-form`)
    activeForm.classList.remove("hidden")

    this.formsTarget.classList.add(`${tabType}-tab`)
  }

  setAllInactive() {
    this.tabTargets.forEach(tab => {
      tab.classList.remove("active")
    })

    this.element.querySelectorAll('.form').forEach(form => {
      form.classList.add("hidden")
    })

    this.formsTarget.classList.remove("sign-up-tab", "sign-in-tab", "quick-login-tab")
  }
}
