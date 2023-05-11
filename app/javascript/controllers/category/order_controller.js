import {Controller} from "@hotwired/stimulus";

// Connects to data-controller="category--order"
export default class extends Controller {
  static targets = ["optionDesc", "optionAsc", "optionDefault", "selectArea"];
  connect() {
    this.parentCategoryId = this.element.dataset.parentCategoryId;
    this.recentChild = this.element.dataset.recentChild;
    this.recentOrder = this.element.dataset.recentOrder;
    this.setSelect(this.recentOrder);
  }
  //  送出連結
  link() {
    window.location.href = `${this.parentCategoryId}?order=${this.recentOrder}&sub_category=${this.recentChild}`;
  }
  // 設定價格排序下拉選單的顯示選項
  setSelect(option) {
    if (option === "price_desc") {
      this.optionDefaultTarget.removeAttribute("selected");
      this.optionDescTarget.setAttribute("selected", "");
    } else if (option === "price_asc") {
      this.optionDefaultTarget.removeAttribute("selected");
      this.optionAscTarget.setAttribute("selected", "");
    }
  }
  // 按下最新連結
  changeRecentOrderBySelector(e) {
    this.recentOrder = e.target.value;
    this.link();
  }
  // 按下價格排序選單
  changeRecentOrderByNewLink(e) {
    e.preventDefault();
    this.recentOrder = "new";
    this.link();
  }
  // 按下子分類連結
  changeRecentChild(e) {
    e.preventDefault();
    this.recentChild = e.target.dataset.childCategory;
    this.link();
  }
}
