import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="shop--product"
export default class extends Controller {
  connect() {
  }
  submitOnChange() {
    this.element.submit()
  }
}
