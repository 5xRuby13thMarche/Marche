import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="product--cart-product"
export default class extends Controller {
  static target = ["cart"]
  // connect(){
  // console.log(123)
  // }
  async send_to_cart(){
    // 打API 
    let url = '/api/categories'
    const response = await post(url, {body: JSON.stringify({main_id: this.main_categoryTarget.value})});
    if (response.ok) {
      const data = await response.json;
      // 印出所選主分類之所有子分類
      data.forEach((s) => {
        const option = document.createElement("option");
        option.value = s.value;
        option.innerHTML = s.content;
        this.subcategoryTarget.appendChild(option);
      });
    }
  }
}
