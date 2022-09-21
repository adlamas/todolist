import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="check"
export default class extends Controller {

  static targets = [ "num1", "num2" ]

  connect() { 
    console.log("Check Controller OLD VERSION connected")
  }
  
  active(event) {
    debugger;
    console.log("CheckController active")
    const id = event.target.dataset.id
    const csrfToken = document.querySelector("[name='csrf-token']").content
  
    fetch(`/tasks/${id}/active`, {
      method: 'POST', // *GET, POST, PUT, DELETE, etc.
      mode: 'cors', // no-cors, *cors, same-origin
      cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
      credentials: 'same-origin', // include, *same-origin, omit
      headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken
      },
      body: JSON.stringify({ completed: event.target.checked })
    })
    .then(response =>  {
      return response.text()
    })
    .then(Turbo.renderStreamMessage)
  }

  sum(){
    const number1 = parseInt(this.num1Target.value)
    const number2 = parseInt(this.num2Target.value)

    const number3 = number1 + number2;
  }
}
