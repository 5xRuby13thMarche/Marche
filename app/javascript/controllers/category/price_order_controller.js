import {Controller} from "@hotwired/stimulus";

// Connects to data-controller="category--price-order"
export default class extends Controller {
  static targets = ["optionDesc", "optionAsc", "optionDefault"];
  connect() {
    this.element.setAttribute(
      "data-action",
      "change->category--price-order#link"
    );
    this.categoryId = this.element.dataset.categoryId;
    this.priceOrder = this.element.dataset.priceOrder;
    this.setSelect(this.priceOrder);
  }
  link() {
    window.location.href = `${this.categoryId}?order=${this.element.value}`;
  }
  setSelect(option) {
    if (option === "price_desc") {
      this.optionDefaultTarget.removeAttribute("selected");
      this.optionDescTarget.setAttribute("selected", "");
    } else if (option === "price_asc") {
      this.optionDefaultTarget.removeAttribute("selected");
      this.optionAscTarget.setAttribute("selected", "");
    }
  }
}
