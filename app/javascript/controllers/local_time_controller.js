import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["time"]

  connect() {
    this.updateTimes()
  }

  updateTimes() {
    const now = new Date()

    this.timeTargets.forEach((el) => {
      const datetime = el.dataset.datetime || el.textContent
      const date = new Date(datetime)

      let options

      if (date.toDateString() === now.toDateString()) {
        options = { hour: "2-digit", minute: "2-digit" }
      } else if (this.isMoreThanYearAgo(date, now)) {
        options = { day: "numeric", month: "short", year: "numeric", hour: "2-digit", minute: "2-digit" }
      } else {
        options = { day: "numeric", month: "short", hour: "2-digit", minute: "2-digit" }
      }

      el.textContent = date.toLocaleString(undefined, options)
    })
  }

  isMoreThanYearAgo(date, now) {
    const oneYearAgo = new Date(now)
    oneYearAgo.setFullYear(now.getFullYear() - 1)
    return date < oneYearAgo
  }
}
