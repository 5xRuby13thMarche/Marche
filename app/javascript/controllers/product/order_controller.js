import {Controller} from "@hotwired/stimulus";

// Connects to data-controller="product--order"
export default class extends Controller {
  static targets = ["optionDesc", "optionAsc", "optionDefault", "selectArea"];
  connect() {
    this.recentOrder = this.element.dataset.recentOrder;
    this.setSelect(this.recentOrder);
  }
  //  送出連結
  link() {
    let location_search = window.location.search;
    let order_index = location_search.indexOf("&order=");
    location_search =
      order_index != -1 ? location_search.split("&order=")[0] : location_search;
    window.location.href = `${location_search}&order=${this.recentOrder}`;
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
}
