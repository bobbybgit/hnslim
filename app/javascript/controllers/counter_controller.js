import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="counter"
export default class extends Controller {
  connect() {
  }

  update(){
    let attendChecks = document.querySelectorAll('[id^="attend"]');
    var attendees = 0
    for (let check of attendChecks) {
      if (check.checked) {
        attendees += 1
      }
    }
    let playerCount = document.getElementById("player_count")
    playerCount.innerHTML = `Total Attendees: ${attendees}`;
    let groupMax = document.getElementById("group_size_max");
    if (groupMax.value > attendees) {
      groupMax.value = attendees
    }
  }
}
