import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="product--sale-info"
export default class extends Controller {
  static targets = ["saleInfo"];
  connect(){
    this.formAmount = 1
    this.formIndex = 1
  }
  // 新增規格欄位最多三個
  increase(e) {
    e.preventDefault();
    if (this.formAmount < 3){
      const cloneContent = this.saleInfoTarget.cloneNode(true);
      // 將節點轉為HTML字串
      let content = cloneContent.outerHTML;
      // console.log(content)
      // 找到字串中[0]並替換為[1]
      content = content.replace(/\[(\d+)\]/g, (match, p1) => `[${parseInt(p1)+this.formIndex}]`)
      // 找到字串中_0_並替換為_1_
      content = content.replace(/_(\d+)_/g, (match, p1) => `_${parseInt(p1)+this.formIndex}_`);
      // 將字串轉為HTML節點
      const container = document.createElement('div')
      container.innerHTML = content;
      const newContent = container.firstChild
      this.saleInfoTarget.insertAdjacentElement("afterend", newContent);
      this.formIndex += 1
      this.formAmount += 1
    }
  }
  
  decrease(e) {
    e.preventDefault();
    console.log(this.saleInfoTarget)
    if (this.element.children.length > 2){
      e.target.closest("div.deleteFields").remove();
      this.formAmount = this.formAmount - 1
    }
  }
}
