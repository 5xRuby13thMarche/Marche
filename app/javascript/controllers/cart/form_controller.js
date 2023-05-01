import {Controller} from "@hotwired/stimulus";

// Connects to data-controller="cart--form"
export default class extends Controller {
  connect() {
    // form表單預設會找尋第一個submit or button進行click事件，因此要preventDefault
    this.element.setAttribute(
      "data-action",
      "keydown.enter->cart--form#submit"
    );
  }
  submit(e) {
    e.preventDefault();
  }
}
