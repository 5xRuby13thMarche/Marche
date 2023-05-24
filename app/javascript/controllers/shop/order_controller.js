import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2";
import {patch} from "@rails/request.js";

// Connects to data-controller="shop--order"
export default class extends Controller {
  
  connect() {
    this.orderProductId = this.element.dataset.orderProductId
  }
  sendShippedMail(e) {
    e.preventDefault();
    // sweet alert
    const swalWithBootstrapButtons = Swal.mixin({
      customClass: {
        confirmButton:
          "border py-2 px-4 mx-2 rounded bg-lime-600 text-white hover:bg-lime-700 text-lg ",
        cancelButton:
          "border py-2 px-4 mx-2 rounded bg-red-400 text-white hover:bg-red-500 text-lg ",
      },
      buttonsStyling: false,
    });
    swalWithBootstrapButtons
      .fire({
        title: "是否要出貨？",
        icon: "warning",
        showCancelButton: true,
        confirmButtonText: "確定",
        cancelButtonText: "取消",
        reverseButtons: true,
      })
      .then((result) => {
        if (result.isConfirmed) {
          swalWithBootstrapButtons.fire("通知買家已出貨");
          this.changeStatus(); // 
        }
      });
  }
  //api
  async changeStatus() {
    let url = `/api/order_products/${this.orderProductId}`;
    const response = await patch(url, {
      body: JSON.stringify({shipping: "shipped"}),
    });
    if (response.ok) {
      // 
      const data = await response.json
      // this.element.innerHTML = this.element.innerHTML.replace("not_shipped", "shipped")
      location.reload();
    }
  }
}
