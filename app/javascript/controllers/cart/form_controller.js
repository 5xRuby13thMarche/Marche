import {Controller} from "@hotwired/stimulus";
import {formatMoney, convertMoneyToNumber} from "./application";
import Swal from "sweetalert2";
import {destroy} from "@rails/request.js";

// Connects to data-controller="cart--form"
export default class extends Controller {
  static targets = [
    "checkbox",
    "itemTotalPrice",
    "totalPrice",
    "productNum",
    "cartItem",
    "submitBtn",
  ];
  connect() {
    // form表單預設會找尋第一個submit or button進行click事件，因此要preventDefault
    this.element.setAttribute(
      "data-action",
      "keydown.enter->cart--form#preventSubmit"
    );
    this.isAllChecked = false;
    this.canPressSubmit = false;
    this.update();
  }
  update() {
    let priceSum = 0;
    let checkedNum = 0;
    setTimeout(() => {
      this.checkboxTargets.forEach((element, index) => {
        if (element.checked) {
          priceSum += convertMoneyToNumber(
            this.itemTotalPriceTargets[index].textContent
          );
          checkedNum += 1;
        }
      });
      this.totalPriceTarget.textContent = formatMoney(priceSum);
      this.productNumTarget.textContent = checkedNum;
      if (checkedNum == 0) {
        this.canPressSubmit = false;
        this.updateSubmitBtn();
      } else {
        this.canPressSubmit = true;
        this.updateSubmitBtn();
      }
    }, 101);
  }
  preventSubmit(e) {
    e.preventDefault();
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
  clearAllCartItems(e) {
    e.preventDefault();
    // sweet alert
    const swalWithBootstrapButtons = Swal.mixin({
      customClass: {
        confirmButton:
          "border py-1 px-2 mx-2 rounded bg-lime-600 text-white hover:bg-lime-700",
        cancelButton:
          "border py-1 px-2 mx-2 rounded bg-red-400 text-white hover:bg-red-500",
      },
      buttonsStyling: false,
    });
    swalWithBootstrapButtons
      .fire({
        title: "清空購物車？",
        icon: "warning",
        showCancelButton: true,
        confirmButtonText: "Yes!",
        cancelButtonText: "No!",
        reverseButtons: true,
      })
      .then((result) => {
        if (result.isConfirmed) {
          swalWithBootstrapButtons.fire("成功刪除");
          // 前後端刪除購物車內商品
          this.deleteAllCartItems();
        }
      });
  }
  // 刪除所有購物車項目
  async deleteAllCartItems() {
    // 前端畫面購物車內商品刪除
    const cartLength = this.cartItemTargets.length;
    for (let i = cartLength - 1; i >= 0; i--) this.cartItemTargets[i].remove();
    // 打API刪除後端購物車內的所有商品
    let url = `/api/cart_products/delete_all`;
    const response = await destroy(url, {
      body: JSON.stringify({cart_id: this.element.dataset.cartId}),
    });
    if (response.ok) {
      // 發布event給購物車icon
      const event = new CustomEvent("update--cart", {detail: "emptyCart"});
      window.dispatchEvent(event);
    }
  }
  // 切換結帳按鈕狀態
  updateSubmitBtn() {
    if (this.canPressSubmit) {
      this.submitBtnTarget.disabled = false;
      this.submitBtnTarget.value = "去買單";
      this.submitBtnTarget.classList.remove("checkout-disabled-btn");
      this.submitBtnTarget.classList.add("checkout-btn");
    } else {
      this.submitBtnTarget.disabled = true;
      this.submitBtnTarget.value = "選擇商品";
      this.submitBtnTarget.classList.remove("checkout-btn");
      this.submitBtnTarget.classList.add("checkout-disabled-btn");
    }
  }
}
