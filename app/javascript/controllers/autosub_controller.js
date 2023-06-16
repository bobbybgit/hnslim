import Autosave from 'stimulus-rails-autosave'

export default class extends Autosave {

  static targets = ["playerSelect"]

  connect() {
    super.connect()
    console.log('Autosub connected')
  }

  save(){
    super.save()
    console.log("saving")
  }

  saveUpdateRating(event){
    super.save()
    console.log("saving")
    let hidden = event.target.previousSibling
    hidden.value = event.target.value
  }

  updatePlayers(event){
    let players = document.getElementById("all_players")
    let update_quantity = event.target.value - players.children.length 
    if (update_quantity < 0){
      while (update_quantity < 0){
        players.removeChild(players.lastChild)
        update_quantity ++
      }
    }else if (update_quantity > 0){
      while (event.target.value > players.children.length) {
        var select_name = `player${players.children.length + 1}`
        var check_name = `check${players.children.length + 1}`
        var new_div = document.createElement("div")
        new_div.className = "player_select"
        var new_select = document.createElement("Select")
        new_select.id = select_name
        new_select.name = select_name
        new_select.className = "player_select_dd"
        
        var new_check = document.createElement("input")
        new_check.type = "checkbox"
        new_check.id = check_name
        new_check.name = check_name
        new_check.checked = true
        
       
        
        new_div.appendChild(new_select)
        new_div.appendChild(new_check)
        players.appendChild(new_div)

        const event = new CustomEvent("set-opt");
        window.dispatchEvent(event);
        console.log(event)
          
        
      }
    }

  }

  setOptions(){
    console.log("go go")
    let playerDropdowns = Array.from(document.getElementsByClassName("player_select_dd"))
    var opt = this.data.get("options")
    var opt_array = JSON.parse(opt)

    console.log(playerDropdowns)

    

    for (let x=0; x < playerDropdowns.length;x++){
      console.log(` x = ${x}`)
      while (playerDropdowns[x].firstChild) {
        playerDropdowns[x].removeChild(playerDropdowns[x].lastChild);
      }
      opt_array.forEach(function(option, i){
        var select_option = new Option(option[0],option[1])
        console.log(` i = ${i}`)
        if (i == x){
          console.log("match")
          playerDropdowns[x].add(select_option)
          playerDropdowns[x].value = option[1]
        }else if ((i + 1) > playerDropdowns.length) {
          playerDropdowns[x].add(select_option)
        }
      })
    }
  }

  updateOptions(){
    
  }
}