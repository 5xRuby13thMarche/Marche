import {Controller} from "@hotwired/stimulus";
import {formatMoney, convertMoneyToNumber} from "./application";

// Connects to data-controller="cart--form"
export default class extends Controller {
  static targets = ["checkbox", "itemTotalPrice", "totalPrice", "productNum"];
  connect() {
    // form表單預設會找尋第一個submit or button進行click事件，因此要preventDefault
    this.element.setAttribute(
      "data-action",
      "keydown.enter->cart--form#preventSubmit"
    );
    this.isAllChecked = false;
  }
  update() {
    let sum = 0;
    let checkedNum = 0;
    setTimeout(() => {
      this.checkboxTargets.forEach((element, index) => {
        if (element.checked) {
          sum += convertMoneyToNumber(
            this.itemTotalPriceTargets[index].textContent
          );
          checkedNum += 1;
        }
      });
      this.totalPriceTarget.textContent = formatMoney(sum);
      this.productNumTarget.textContent = checkedNum;
    }, 101);
  }
  preventSubmit(e) {
    e.preventDefault();
  }
  checkAllBox() {
    if (this.isAllChecked) {
      this.isAllChecked = false;
      for (let i = 0; i < this.checkboxTargets.length; i++) {
        this.checkboxTargets[i].checked = false;
      }
    } else {
      this.isAllChecked = true;
      for (let i = 0; i < this.checkboxTargets.length; i++) {
        this.checkboxTargets[i].checked = true;
      }
    }
    this.update();
  }
}
