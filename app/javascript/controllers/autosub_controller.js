import Autosave from 'stimulus-rails-autosave'

export default class extends Autosave {

  static targets = ["playerSelect", "link"]

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

  saveUpdateGroupMembers(event){
    super.save()
    console.log("saving")
    let group = event.target.value
    console.log(group)
    var url = this.linkTarget.dataset["url"]
    if (group > 0){
      url = `${this.linkTarget.dataset["url"]}?group=${group}`
    }
    console.log(url)
    let frame = document.querySelector("turbo-frame#content")
    frame.src = url
    frame.reload()
   
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