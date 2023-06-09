import {Controller} from "@hotwired/stimulus";
import {post} from "@rails/request.js";
import Swal from "sweetalert2";

// Connects to data-controller="product--cart-product"
export default class extends Controller {
  static targets = ["saleInfoId", "quantity", "storage", "inputArea"];
  connect() {
    this.element.setAttribute(
      "data-action",
      "keydown.enter->product--cart-product#preventSubmit"
    );
    const storage = this.storageTarget.textContent.match(/\d+/g);
    this.storageNum = parseInt(storage);
    this.saleInfoId = this.saleInfoIdTarget.value;
    this.quantityNum = Number(this.quantityTarget.value);
  }

  //判斷輸入是否超過庫存or小於0
  setQuantityTarget() {
    if (this.quantityNum <= 0) this.quantityNum = 1;
    if (this.quantityNum > this.storageNum) {
      this.quantityNum = this.storageNum;
      // 顯示當前存貨的提示訊息
      // 待開發.......
    }
    this.quantityTarget.value = this.quantityNum;
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
  // User typing quantity
  updateQuantity() {
    this.quantityNum = Math.floor(this.quantityTarget.value);
    this.setQuantityTarget();
  }
  // + button pressed
  increment(e) {
    e.preventDefault();
    this.lowerOpacity();
    setTimeout(() => {
      this.upperOpacity();
      this.quantityNum += 1;
      this.setQuantityTarget();
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
    }, 100);
  }
  preventSubmit(e) {
    e.preventDefault();
  }

  //打API
  async send(e) {
    e.preventDefault();
    const url = "/api/cart_products";
    const isCorrect =
      this.quantityNum <= this.storageNum &&
      this.quantityNum > 0 &&
      Number.isInteger(this.quantityNum);
    // 判斷數量格式是否正確
    if (isCorrect) {
      const response = await post(url, {
        body: JSON.stringify({
          sale_info_id: this.saleInfoId,
          quantity: this.quantityNum,
        }),
      });
      if (response.ok) {
        const data = await response.json;
        Swal.fire({
          icon: "success",
          title: "加入購物車成功",
          showConfirmButton: false,
          timer: 1000,
          width: "20em",
          heightAuto: false,
          color: "#F28500",
          background: "#eee",
        });
        // 如果是新增商品到購物車，發布event給購物車icon
        if (data.ok == "create success！") {
          const event = new CustomEvent("update--cart", {
            detail: "increaseCart",
          });
          window.dispatchEvent(event);
        }
      }
    } else {
      const message = "數量輸入錯誤";
      Swal.fire({
        icon: "error",
        title: message,
        showConfirmButton: false,
        timer: 1000,
        width: "20em",
        heightAuto: false,
        color: "#333",
        background: "#eee",
      });
    }
  }
}
