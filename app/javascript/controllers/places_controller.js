import PlacesAutocomplete from 'stimulus-places-autocomplete'

export default class extends PlacesAutocomplete {

  
  connect() {
    super.connect()
    console.log('Places controller connected.')

    // The google.maps.places.Autocomplete instance.
    this.autocomplete
    console.log(this.autocomplete)
  }

  // You can override the `initAutocomplete` method here.
  initAutocomplete() {
    super.initAutocomplete()
  }

  // You can override the `placeChanged` method here.
  placeChanged() {
    
    super.placeChanged()
    
    let place = this.autocomplete.getPlace()
    this.longitudeTarget.value = place.geometry.location.lng()
    this.latitudeTarget.value = place.geometry.location.lat()
    console.log(this.latitudeTarget.value)
    
  }

  updateGeo(){
    
    try{
      const options = {
        fields: ["formatted_address", "geometry", "name"],
        strictBounds: false,
      };
      let inputValue = document.getElementById("location").value
      let newPlace = new google.maps.places.autocomplete(inputValue,options)
      console.log(newPlace.getPlace)
      this.longitudeTarget.value = place.geometry.location.lng()
      this.latitudeTarget.value = place.geometry.location.lat()
    }catch(err){
      this.longitudeTarget.value = null
      this.latitudeTarget.value = null
      console.log("nulled")
    }

  }



  // You can set the Autocomplete options in this getter.
  get autocompleteOptions() {
    return {
      fields: ['address_components', 'geometry'],
    }
  }
}