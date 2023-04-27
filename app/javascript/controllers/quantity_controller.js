// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  
  static targets = ["value"]

  increase(){
    this.valueTarget.value++;
  } 
  decrease(){
    if (parseInt(this.valueTarget.value) > 0){
      this.valueTarget.value = parseInt(this.valueTarget.value) - 1
    }
  } 
}