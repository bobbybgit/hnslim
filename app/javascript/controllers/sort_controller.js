import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sort"
export default class extends Controller {
  connect() {
    console.log("Sort controller connected")
  }

  sort(event){

    
    let sorter = event.target.id
    let column = document.getElementById("column")
    let direction = document.getElementById("direction")
    console.log(`sorting by ${sorter} ${column.value} ${direction.value}`)
    if (column.value == sorter) {
      if (direction.value == "down"){
        console.log(`changing direction up`)
        direction.value = "up";
      }else{
        console.log(`changing direction down`)
        direction.value = "down";
      }
    }else{
      console.log(`changing column`)
      column.value = sorter
      direction.value = "down"
    }

    const new_event = new CustomEvent("sub-all");
    window.dispatchEvent(new_event);
  }
}