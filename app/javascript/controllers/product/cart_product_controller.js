import { Controller } from "@hotwired/stimulus"
import {post} from "@rails/request.js";
import Swal from 'sweetalert2';

// Connects to data-controller="product--cart-product"
export default class extends Controller {
  static targets = ["saleInfoId", "quantity", "storage"]

  async send(e) {
    e.preventDefault(); 
    const storage = this.storageTarget.textContent.match(/\d+/g);
    const numStr = storage.toString()
    const url = '/api/cart_product';
    const saleInfoId = this.saleInfoIdTarget.value;
    const quantity = Number(this.quantityTarget.value);
    const isCorrect = quantity <= numStr && quantity > 0 && Number.isInteger(quantity)
    // 判斷數量格式是否正確
    if (isCorrect){
       //打API
      const response = await post(url, {body: JSON.stringify({sale_info_id: saleInfoId, quantity: quantity})});
      if (response.ok) {
        console.log("ok")
        Swal.fire({
          icon: 'success',
          title: '加入購物車成功',
          showConfirmButton: false,
          timer: 1000,
          width: '20em',
          heightAuto: false, 
          color: '#F28500',
          background:'#eee',
        })
      }  
    }else{
      const message = '數量輸入錯誤'
      Swal.fire({
        icon: 'error',
        title: message,
        showConfirmButton: false,
        timer: 1000,
        width: '20em',
        heightAuto: false, 
        color: '#333',
        background:'#eee',
      })
      throw new Error('Invalid quantity');
    } 
  }
}
