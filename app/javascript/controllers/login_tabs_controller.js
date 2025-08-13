import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "tab", "forms" ]

  switchTab(event) {
    const selectedTab = event.currentTarget
    const tabType = selectedTab.dataset.tab

    this.tabTargets.forEach(tab => {
      tab.classList.remove("active")
    })

    this.element.querySelectorAll('.form').forEach(form => {
      form.style.display = "none"
    })

    selectedTab.classList.add("active")

    const activeForm = this.element.querySelector(`.${tabType}-form`)
    activeForm.style.display = "block"

    this.formsTarget.classList.remove("sign-up-tab", "sign-in-tab", "quick-login-tab")
    this.formsTarget.classList.add(`${tabType}-tab`)
  }
}
