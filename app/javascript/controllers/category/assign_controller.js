import { Controller } from "@hotwired/stimulus"
import {post} from "@rails/request.js";

// Connects to data-controller="category--assign"
export default class extends Controller {
  static targets = ["main_category", "subcategory", "show"]

  async choose(){
    // 避免子分類重複新增
    this.subcategoryTarget.innerHTML = ''
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

  whichChoose(){
    // 顯示所選子分類
    const selectedOption = this.subcategoryTarget.options[this.subcategoryTarget.selectedIndex]
    const selectedText = selectedOption.text  
    this.showTarget.textContent = selectedText
  
  
  }


  // async myMethod () {
  //   const request = new FetchRequest('post', 'localhost:3000/my_endpoint', { body: JSON.stringify({ name: 'Request.JS' }) })
  //   const response = await request.perform()
  //   if (response.ok) {
  //     const body = await response.text
  //     // Do whatever do you want with the response body
  //     // You also are able to call `response.html` or `response.json`, be aware that if you call `response.json` and the response contentType isn't `application/json` there will be raised an error.
  //   }
  // }
}
