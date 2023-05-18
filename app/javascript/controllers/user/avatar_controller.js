import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="user--avatar"
export default class extends Controller {
  static targets = ["input", "initialPic", "preview"];
  connect() {
    this.inputTarget.setAttribute(
      "data-action",
      "change->user--avatar#renderImage"
    );
  }

  renderImage() {
    let file = this.inputTarget.files[0];
    let reader = new FileReader();
    reader.readAsDataURL(file);

    reader.onload = () => {
      this.previewTarget.classList.remove("hidden");
      this.previewTarget.src = reader.result;
      this.initialPicTarget.classList.add("hidden");
    };
  }
}
