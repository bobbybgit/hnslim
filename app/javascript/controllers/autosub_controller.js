import Autosave from 'stimulus-rails-autosave'

export default class extends Autosave {
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
        var opt = this.data.get("options")
        var opt_array = JSON.parse(opt)
        var new_check = document.createElement("input")
        new_check.type = "checkbox"
        new_check.id = check_name
        new_check.name = check_name
        new_check.checked = true
        
        opt_array.forEach(function(option, i){
          var select_option = new Option(option[0],option[1])
          new_select.add(select_option)
        })
        
        new_div.appendChild(new_select)
        new_div.appendChild(new_check)
        players.appendChild(new_div)



        console.log(opt_array)
        console.log(typeof opt_array)

        
      }
    }
  }
}