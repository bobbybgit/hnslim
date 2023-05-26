import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="mobile"
export default class extends Controller {
  connect() {
    console.log("Mobile Menu Connected")
  }

  menuClick(){
    let menu = document.getElementById("mobile_menu")
    if (getComputedStyle(menu).display == "none"){
      menu.style.display = "flex"
    }else{
      menu.style.display = "none"
    }
   }

   menuClose(){
    let menu = document.getElementById("mobile_menu")
    let header = document.getElementById("mobile_header")
    if (getComputedStyle(header).display == "flex"){
      menu.style.display = "none"
   }
  }
 }

