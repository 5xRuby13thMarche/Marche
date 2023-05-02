import {Controller} from "@hotwired/stimulus";

// Connects to data-controller="cart--form"
export default class extends Controller {
  static targets = ["checkbox", "itemTotalPrice", "totalPrice", "productNum"];
  connect() {
    // form表單預設會找尋第一個submit or button進行click事件，因此要preventDefault
    this.element.setAttribute(
      "data-action",
      "keydown.enter->cart--form#preventSubmit"
    );
    this.isAllChecked = false;
  }
  update() {
    let sum = 0;
    let checkedNum = 0;
    for (let i = 0; i < this.checkboxTargets.length; i++) {
      if (this.checkboxTargets[i].checked) {
        sum += this.convertMoneyToNumber(
          this.itemTotalPriceTargets[i].textContent
        );
        checkedNum += 1;
      }
    }
    this.totalPriceTarget.textContent = this.formatMoney(sum);
    this.productNumTarget.textContent = checkedNum;
  }
  boxChecked() {}
  totalPriceChanged() {}
  convertMoneyToNumber(price) {
    return Number(price.split("$")[1].split(",").join(""));
  }
  preventSubmit(e) {
    e.preventDefault();
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
  checkAllBox() {
    if (this.isAllChecked) {
      this.isAllChecked = false;
      for (let i = 0; i < this.checkboxTargets.length; i++) {
        this.checkboxTargets[i].checked = false;
      }
    } else {
      this.isAllChecked = true;
      for (let i = 0; i < this.checkboxTargets.length; i++) {
        this.checkboxTargets[i].checked = true;
      }
    }
    this.update();
  }
}
