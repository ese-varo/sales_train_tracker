import { Controller } from "../application.js"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.menuTarget.hidden = true
  }

  toggle() {
    this.menuTarget.hidden = !this.menuTarget.hidden
  }

  hide(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.hidden = true
    }
  }
}
