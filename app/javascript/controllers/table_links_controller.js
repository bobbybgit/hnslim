import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="table-links"
export default class extends Controller {
  connect() {
    console.log("Table Links Controller Connected")
  }

  player(event){
    var input = event.target
    console.log("Player Clicked")
    while (input.className != "data_row_clickable"){
      input = input.parentElement
      console.log("going up")
    }
    console.log(`ID = ${input.id}`)

    let url = `/games?id=${input.id}`
    
    let frame = document.querySelector("turbo-frame#content")
    frame.src = url
    frame.reload()
  }
}
