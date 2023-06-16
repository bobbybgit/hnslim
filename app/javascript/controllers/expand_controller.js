import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="expand"
export default class extends Controller {
  static targets = [];

  connect(){
    console.log("Expand Controller Connected");
    
  }

  expand(event){
    let clicker = event.target

    while (clicker.className != "expand_header"){
      clicker = clicker.parentElement
    }
    let expandee = clicker.nextElementSibling;
    let icon = clicker.lastChild;
    if (getComputedStyle(expandee).display != "none"){
      expandee.style.display = "none";
      icon.innerHTML = "expand_more";
    }else{
      expandee.style.display = "flex";
      icon.innerHTML = "expand_less";
    }

   }

   
  expandTable(event){
    let clicker = event.target

    while (clicker.className != "expand_header"){
      clicker = clicker.parentElement
    }
    let expandee = clicker.nextElementSibling;
    let icon = clicker.lastChild;
    if (getComputedStyle(expandee).display != "none"){
      expandee.style.display = "none";
      icon.innerHTML = "expand_more";
    }else{
      expandee.style.display = "table";
      icon.innerHTML = "expand_less";
    }

   }
  }