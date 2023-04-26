import {Controller} from "@hotwired/stimulus";
import {Turbo} from "@hotwired/turbo-rails";
import {post} from "@rails/request.js";

// Connects to data-controller="product--like"
export default class extends Controller {
  static targets = ["heart", "amount"];
  connect() {
    this.isLiked = this.element.dataset.userLike === "true" ? true : false;
    this.productId = this.element.dataset.productId;
    this.likeAmount = Number(this.amountTarget.textContent);
    this.changeHeartClass();
  }

  async like_product() {
    // 切換喜歡狀態
    this.isLiked = !this.isLiked;
    this.changeHeartClass();
    this.changeLikeAmount();

    // 打API
    let url = (this.isLiked)?`/api/products/${this.productId}/like`:`/api/products/${this.productId}/dislike`
    const response = await post(url, {body: JSON.stringify({like: "like"})});
    if (response.ok) {
      const data = await response.json;
      if (data.signInState === "false") window.location.href = data.signInUrl;
    }
  }
  changeHeartClass() {
    if (this.isLiked) {
      this.heartTarget.classList.remove("fa-regular");
      this.heartTarget.classList.add("fa-solid");
    } else {
      this.heartTarget.classList.remove("fa-solid");
      this.heartTarget.classList.add("fa-regular");
    }
  }
  changeLikeAmount() {
    if (this.isLiked) {
      this.likeAmount += 1;
    } else {
      this.likeAmount -= 1;
    }
    this.amountTarget.textContent = this.likeAmount;
  }
}
