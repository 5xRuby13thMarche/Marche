import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="product--sale-info"
export default class extends Controller {
  static targets = ["saleInfo"];
  connect(){
    // this.copyStr = this.element.innerHTML.replace('data-product--sale-info-target="saleInfo"', 'data-product--sale-info-target="template"')
    // console.log(this.copyStr)
  }
  increase(e) {
    e.preventDefault();
    const content = this.saleInfoTarget.cloneNode(true);
    console.log(content);
    this.saleInfoTarget.insertAdjacentElement("afterend", content);
  }
  
  decrease(e) {
    e.preventDefault();
    if (this.element.children.length > 1){
      e.target.closest("div.deleteFields").remove();
    }
  }
}
