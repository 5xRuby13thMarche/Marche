import {Controller} from "@hotwired/stimulus";

// Connects to data-controller="cart--item"
export default class extends Controller {
  static targets = ["quantity", "inputArea", "itemTotalPrice"];
  connect() {
    this.quantityNum = Number(this.quantityTarget.value);
    this.updateItemTotalPrice();
  }
  updateQuantity() {
    if (this.quantityTarget.value < 1) {
      this.quantityNum = 1;
      this.quantityTarget.value = this.quantityNum;
    }
    this.quantityNum = Number(this.quantityTarget.value);
    this.updateItemTotalPrice();
  }
  increment(e) {
    e.preventDefault();
    this.lowerOpacity();
    setTimeout(() => {
      this.upperOpacity();
      this.quantityNum += 1;
      this.quantityTarget.value = this.quantityNum;
      this.updateItemTotalPrice();
    }, 100);
  }
  decrement(e) {
    e.preventDefault();
    this.lowerOpacity();
    setTimeout(() => {
      this.upperOpacity();
      if (this.quantityNum <= 1) return;
      this.quantityNum -= 1;
      this.quantityTarget.value = this.quantityNum;
      this.updateItemTotalPrice();
    }, 100);
  }
  lowerOpacity() {
    this.inputAreaTarget.classList.remove("opacity-100");
    this.inputAreaTarget.classList.add("opacity-30");
  }
  upperOpacity() {
    this.inputAreaTarget.classList.remove("opacity-30");
    this.inputAreaTarget.classList.add("opacity-100");
  }
  updateItemTotalPrice() {
    let itemPrice =
      Number(this.itemTotalPriceTarget.dataset.unitPrice) * this.quantityNum;
    this.itemTotalPriceTarget.textContent = this.formatMoney(itemPrice);
  }
  formatMoney(price) {
    let integerPart = price.toString().split(".")[0].split("").reverse();
    for (let i = 3; i < integerPart.length; i += 4) {
      integerPart.splice(i, 0, ",");
    }
    let decimalPart = price.toString().split(".")[1];
    decimalPart = decimalPart == undefined ? "" : `.${decimalPart}`;
    return `$${integerPart.reverse().join("")}${decimalPart}`;
  }
}
