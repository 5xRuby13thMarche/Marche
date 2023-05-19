import {Controller} from "@hotwired/stimulus";
import {patch} from "@rails/request.js";
import {formatMoney} from "./application";
import Swal from "sweetalert2";

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
    this.setQuantityTarget();
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
  // 設定單一項目的總價
  updateItemTotalPrice() {
    let itemPrice =
      Number(this.itemTotalPriceTarget.dataset.unitPrice) * this.quantityNum;
    this.itemTotalPriceTarget.textContent = formatMoney(itemPrice);
  }
  // set quantityTarget
  setQuantityTarget() {
    if (this.quantityNum <= 0) this.quantityNum = 1;
    if (this.quantityNum > this.storageNum) this.quantityNum = this.storageNum;
    this.quantityTarget.value = this.quantityNum;
    this.updateItemTotalPrice();
    // 庫存提示
    if (this.quantityNum == this.storageNum) {
      this.revealStorageWarning();
    } else {
      this.hideStorageWarning();
    }
  }
  hideStorageWarning() {
    this.storageWarningTarget.classList.add("hidden");
  }
  revealStorageWarning() {
    this.storageWarningTarget.classList.remove("hidden");
  }
  // API
  async updateCartProductQuantityViaAPI() {
    let url = `/api/cart_products/${this.cartProductId}`;
    const response = await patch(url, {
      body: JSON.stringify({quantity: this.quantityNum}),
    });
    if (response.ok) {
      const data = await response.json;
      // console.log(data);
    }
  }
  // 刪除鍵顯示toast，發布刪除項目的訊息
  showDeleteToast() {
    const Toast = Swal.mixin({
      toast: true,
      position: "top-end",
      showConfirmButton: false,
      timer: 3000,
      timerProgressBar: false,
      didOpen: (toast) => {
        toast.addEventListener("mouseenter", Swal.stopTimer);
        toast.addEventListener("mouseleave", Swal.resumeTimer);
      },
    });
    Toast.fire({
      icon: "success",
      title: "成功刪除",
    });
    // 發布event
    const event = new CustomEvent("update--cart", {detail: "decreaseCart"});
    window.dispatchEvent(event);
  }
  // 接收event，刪除購物車商品項目本身
  destroySelfItem(e) {
    if (e.detail == "emptyCart") this.element.remove();
  }
}
