import {Controller} from "@hotwired/stimulus";
import Swal from "sweetalert2";

// Connects to data-controller="product--form"
export default class extends Controller {
  static targets = [
    "name",
    "images",
    "description",
    "price",
    "spec",
    "storage",
    "category",
  ];
  connect() {}
  submit(e) {
    e.preventDefault();
    // 驗證 name
    const name = this.nameTarget.value;
    if (name.length < 2) {
      this.nameTarget.classList.remove("border-gray-200");
      this.nameTarget.classList.add("border-red-500");
      const Toast = Swal.mixin({
        toast: true,
        position: "top",
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true,
        didOpen: (toast) => {
          toast.addEventListener("mouseenter", Swal.stopTimer);
          toast.addEventListener("mouseleave", Swal.resumeTimer);
        },
      });

      Toast.fire({
        icon: "error",
        title: "名稱需大於兩個字符！",
      });
      return;
    } else {
      this.nameTarget.classList.add("border-gray-200");
      this.nameTarget.classList.remove("border-red-500");
    }

    // 驗證 images
    const images = this.imagesTarget.files;
    if (images.length === 0) {
      this.imagesTarget.classList.add("text-red-500");
      const Toast = Swal.mixin({
        toast: true,
        position: "top",
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true,
        didOpen: (toast) => {
          toast.addEventListener("mouseenter", Swal.stopTimer);
          toast.addEventListener("mouseleave", Swal.resumeTimer);
        },
      });

      Toast.fire({
        icon: "error",
        title: "須至少上傳一張照片！",
      });
      return;
    } else {
      this.imagesTarget.classList.remove("text-red-500");
    }

    // 驗證 category
    var category = this.categoryTarget.value;
    if (category === "") {
      this.categoryTarget.classList.remove("border-gray-200");
      this.categoryTarget.classList.add("border-red-500");
      const Toast = Swal.mixin({
        toast: true,
        position: "top",
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true,
        didOpen: (toast) => {
          toast.addEventListener("mouseenter", Swal.stopTimer);
          toast.addEventListener("mouseleave", Swal.resumeTimer);
        },
      });

      Toast.fire({
        icon: "error",
        title: "請選擇分類！",
      });

      return;
    } else {
      this.categoryTarget.classList.add("border-gray-200");
      this.categoryTarget.classList.remove("border-red-500");
    }

    // 驗證 description
    const description = this.descriptionTarget.value;
    if (description.length < 10) {
      this.descriptionTarget.classList.remove("border-gray-200");
      this.descriptionTarget.classList.add("border-red-500");
      const Toast = Swal.mixin({
        toast: true,
        position: "top",
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true,
        didOpen: (toast) => {
          toast.addEventListener("mouseenter", Swal.stopTimer);
          toast.addEventListener("mouseleave", Swal.resumeTimer);
        },
      });

      Toast.fire({
        icon: "error",
        title: "敘述至少超過10個字符！",
      });

      return;
    } else {
      this.descriptionTarget.classList.add("border-gray-200");
      this.descriptionTarget.classList.remove("border-red-500");
    }

    // 驗證 spec
    const spec = this.specTarget.value;
    if (spec.length < 2) {
      this.specTarget.classList.remove("border-gray-200");
      this.specTarget.classList.add("border-red-500");
      const Toast = Swal.mixin({
        toast: true,
        position: "top",
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true,
        didOpen: (toast) => {
          toast.addEventListener("mouseenter", Swal.stopTimer);
          toast.addEventListener("mouseleave", Swal.resumeTimer);
        },
      });

      Toast.fire({
        icon: "error",
        title: "銷售資訊：規格長度至少2字符！",
      });
      return;
    } else {
      this.specTarget.classList.add("border-gray-200");
      this.specTarget.classList.remove("border-red-500");
    }

    // 驗證 price
    const price = Number(this.priceTarget.value);
    if (isNaN(price) || price <= 0) {
      this.priceTarget.classList.remove("border-gray-200");
      this.priceTarget.classList.add("border-red-500");
      const Toast = Swal.mixin({
        toast: true,
        position: "top",
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true,
        didOpen: (toast) => {
          toast.addEventListener("mouseenter", Swal.stopTimer);
          toast.addEventListener("mouseleave", Swal.resumeTimer);
        },
      });

      Toast.fire({
        icon: "error",
        title: "銷售資訊：請輸入有效價格！",
      });
      return;
    } else {
      this.priceTarget.classList.add("border-gray-200");
      this.priceTarget.classList.remove("border-red-500");
    }

    // 驗證 storage
    const storage = this.storageTarget.value;
    if (isNaN(storage) || storage <= 0) {
      this.storageTarget.classList.remove("border-gray-200");
      this.storageTarget.classList.add("border-red-500");
      const Toast = Swal.mixin({
        toast: true,
        position: "top",
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true,
        didOpen: (toast) => {
          toast.addEventListener("mouseenter", Swal.stopTimer);
          toast.addEventListener("mouseleave", Swal.resumeTimer);
        },
      });

      Toast.fire({
        icon: "error",
        title: "銷售資訊：庫存必須為0以上!",
      });
      return;
    } else {
      this.storageTarget.classList.add("border-gray-200");
      this.storageTarget.classList.remove("border-red-500");
    }

    this.element.submit();
  }
}
