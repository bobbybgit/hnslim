// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails



import "@hotwired/turbo-rails"
import "controllers"

window.initMap = function () {
    console.log("Init map running")
    const event = new Event('google-maps-callback', {
      bubbles: true,
      cancelable: true,
    })
    window.dispatchEvent(event)
    console.log("event dispatched")
  }




