import {Controller} from "@hotwired/stimulus";
import {get} from "@rails/request.js";

// Connects to data-controller="category--assign"
export default class extends Controller {
  static targets = ["main_category", "subcategory", "show"];
  connect() {}
  async choose() {
    // 避免子分類重複新增
    this.subcategoryTarget.innerHTML = "";
    // 打API
    let url = `/api/categories/${this.main_categoryTarget.value}`;
    const response = await get(url);
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

  whichChoose() {
    // 顯示所選子分類
    const subSelectedOption =
      this.subcategoryTarget.options[this.subcategoryTarget.selectedIndex];
    const mainSelectedOption =
      this.main_categoryTarget.options[this.main_categoryTarget.selectedIndex];
    const selectedText = `${mainSelectedOption.text} > ${subSelectedOption.text}`;
    this.showTarget.textContent = selectedText;
  }
}
