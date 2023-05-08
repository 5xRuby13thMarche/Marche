import {Controller} from "@hotwired/stimulus";
import {post, destroy} from "@rails/request.js";
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
    "deleteBtn",
  ];
  connect() {
    this.cartProductId = this.element.dataset.cartProductId;
    this.quantityNum = Number(this.quantityTarget.value);
    this.storageNum = Number(this.quantityTarget.dataset.storage);
    if (this.storageNum <= 0) this.disableComponents(); // 庫存為0
    this.updateItemTotalPrice();
    // this.deleteBtnTarget.setAttribute(data-controller)
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
    this.itemTotalPriceTarget.textContent = formatMoney(itemPrice);
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
    let url = `/api/carts/${this.cartProductId}/edit`;
    const response = await post(url, {
      body: JSON.stringify({quantity: this.quantityNum}),
    });
    if (response.ok) {
      const data = await response.json;
      // console.log(data);
    }
  }
  // Delete cart item

  deleteCartItem(e) {
    e.preventDefault();
    const url = e.currentTarget.href;
    const csrfToken = document.querySelector('[name="csrf-token"]').content;

    Swal.fire({
      title: "Are you sure?",
      text: "This action cannot be undone.",
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#3085d6",
      cancelButtonColor: "#d33",
      confirmButtonText: "Delete",
    }).then((result) => {
      if (result.isConfirmed) {
        fetch(url, {
          method: "DELETE",
          headers: {
            "X-CSRF-Token": csrfToken,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({}),
        }).then((response) => {
          if (response.ok) {
            this.element.remove();
          } else {
            Swal.fire({
              icon: "error",
              title: "Oops...",
              text: "Something went wrong!",
            });
          }
        });
      }
    });
  }
}
