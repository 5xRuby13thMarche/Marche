import Swal from 'sweetalert2'
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  static targets = ["notice", "alert"]
  connect() {
    const Toast = Swal.mixin({
      toast: true,
      position: 'top',
      showConfirmButton: false,
      timer: 3000,
      timerProgressBar: true,
      didOpen: (toast) => {
        toast.addEventListener('mouseenter', Swal.stopTimer)
        toast.addEventListener('mouseleave', Swal.resumeTimer)
      }
    })
    if (this.noticeTarget.textContent) {
      Toast.fire({
        icon: 'success',
        title: this.noticeTarget.textContent
      })
    }else {
      Toast.fire({
        icon: 'warning',
        title: this.alertTarget.textContent
      })
    }
  }
}
