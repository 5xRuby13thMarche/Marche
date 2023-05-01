import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="product--sale-info"
export default class extends Controller {
  static targets = ["saleInfo", "template"];
  
  increase(e) {
    e.preventDefault();
    const content = this.templateTarget.cloneNode(true);
    this.saleInfoTarget.insertAdjacentElement("afterbegin", content);
  }
  
  decrease(e) {
    e.preventDefault();
    if (this.saleInfoTarget.children.length > 1){
      e.target.closest("div.deleteFields").remove();
    }
  }
}
