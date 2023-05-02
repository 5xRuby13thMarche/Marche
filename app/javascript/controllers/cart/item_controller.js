import {Controller} from "@hotwired/stimulus";
import {post} from "@rails/request.js";

// Connects to data-controller="cart--item"
export default class extends Controller {
  static targets = [
    "quantity",
    "inputArea",
    "itemTotalPrice",
    "checkbox",
    "storageWarning",
  ];
  connect() {
    this.cartProductId = this.element.dataset.cartProductId;
    this.quantityNum = Number(this.quantityTarget.value);
    this.storageNum = Number(this.quantityTarget.dataset.storage);
    if (this.storageNum <= 0) this.disableComponents(); // 庫存為0
    this.updateItemTotalPrice();
  }
  // disable components when storage is 0
  disableComponents() {
    this.checkboxTarget.setAttribute("disabled", "");
    this.lowerOpacity();
    const childrenElements = this.inputAreaTarget.children;
    for (let i = 0; i < childrenElements.length; i++) {
      childrenElements[i].setAttribute("disabled", "");
    }
    this.quantityNum = 0;
    this.setQuantityTarget();
    this.updateCartProductQuantityViaAPI();
  }
  // User typing quantity
  updateQuantity() {
    this.quantityNum = Math.floor(this.quantityTarget.value);
    this.setQuantityTarget();
    this.updateCartProductQuantityViaAPI();
  }
  // + button pressed
  increment(e) {
    e.preventDefault();
    this.lowerOpacity();
    setTimeout(() => {
      this.upperOpacity();
      this.quantityNum += 1;
      this.setQuantityTarget();
      this.updateCartProductQuantityViaAPI();
    }, 100);
  }
  // - button pressed
  decrement(e) {
    e.preventDefault();
    this.lowerOpacity();
    setTimeout(() => {
      this.upperOpacity();
      this.quantityNum -= 1;
      this.setQuantityTarget();
      this.updateCartProductQuantityViaAPI();
    }, 100);
  }
  // lower opacity for flashing input area
  lowerOpacity() {
    this.inputAreaTarget.classList.remove("opacity-100");
    this.inputAreaTarget.classList.add("opacity-30");
  }
  // upper opacity for flashing input area
  upperOpacity() {
    this.inputAreaTarget.classList.remove("opacity-30");
    this.inputAreaTarget.classList.add("opacity-100");
  }
  // set total price
  updateItemTotalPrice() {
    let itemPrice =
      Number(this.itemTotalPriceTarget.dataset.unitPrice) * this.quantityNum;
    this.itemTotalPriceTarget.textContent = this.formatMoney(itemPrice);
  }
  // format price to money
  formatMoney(price) {
    let integerPart = price.toString().split(".")[0].split("").reverse();
    for (let i = 3; i < integerPart.length; i += 4) {
      integerPart.splice(i, 0, ",");
    }
    let decimalPart = price.toString().split(".")[1];
    decimalPart = decimalPart == undefined ? "" : `.${decimalPart}`;
    return `$${integerPart.reverse().join("")}${decimalPart}`;
  }
  // set quantityTarget
  setQuantityTarget() {
    if (this.quantityNum <= 0) this.quantityNum = 1;
    if (this.quantityNum > this.storageNum) {
      this.quantityNum = this.storageNum;
      // 顯示當前存貨的提示訊息
      // 待開發.......
    }
    this.quantityTarget.value = this.quantityNum;
    this.updateItemTotalPrice();
    // 庫存提示
    if (this.quantityNum == this.storageNum) {
      this.revealStorageWarning();
    } else {
      this.hiddenStorageWarning();
    }
  }
  hiddenStorageWarning() {
    this.storageWarningTarget.classList.add("hidden");
  }
  revealStorageWarning() {
    this.storageWarningTarget.classList.remove("hidden");
  }
  // API
  async updateCartProductQuantityViaAPI() {
    let url = `/api/carts/${this.cartProductId}/edit`;
    const response = await post(url, {
      body: JSON.stringify({quantity: this.quantityNum}),
    });
    if (response.ok) {
      const data = await response.json;
      // console.log(data);
    }
  }
}
