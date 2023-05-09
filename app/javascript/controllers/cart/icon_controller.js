import {Controller} from "@hotwired/stimulus";

// Connects to data-controller="cart--icon"
export default class extends Controller {
  static targets = ["cartNum"];
  connect() {
    this.currentProductNum = Number(this.cartNumTarget.dataset.productCount);
    if (this.currentProductNum == NaN) this.currentProductNum = 0;
    this.updateNum(this.currentProductNum);
  }
  updateNum(num) {
    if (num === 0) {
      this.cartNumTarget.classList.add("hidden");
      return;
    } else {
      this.cartNumTarget.classList.remove("hidden");
    }
    this.cartNumTarget.textContent = num;
  }
  updateCart(e) {
    if (e.detail === "emptyCart") {
      this.currentProductNum = 0;
    } else if (e.detail === "decreaseCart") {
      this.currentProductNum -= 1;
    } else if (e.detail == "increaseCart") {
      this.currentProductNum += 1;
    }
    this.updateNum(this.currentProductNum);
  }
}
