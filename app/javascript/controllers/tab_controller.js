import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

static targets = ['tab'];




  connect(){
    console.log("Tab Controller Connected");
    this.tabTargets[0].style.textDecoration = "underline"
    
        
  }

  tabSelect(event){
    let evTarg = event.target
    while (!this.tabTargets.includes(evTarg)){
      evTarg = evTarg.parentElement
    }
    this.tabTargets.forEach((targ, i) => {
      console.log(targ)
      if (targ != evTarg){
        targ.style.textDecoration = "underline"
      }else{
        targ.style.textDecoration = "none"
      }
    });
    
  }
}
