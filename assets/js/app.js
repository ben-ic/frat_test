// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
import { ApolloClient, InMemoryCache, gql } from '@apollo/client/core';


const apolloClient = new ApolloClient({
  uri: '/api/graphql',
  cache: new InMemoryCache(),
});

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken}
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket


window.checkOtp = function checkOtp(code) {
  apolloClient
  .query({
    query: gql`
      {
        otp(otp: "${code}") {
          result
        }
      }
    `,
  })
  .then((result) => {return updateOtpResult(result.data.otp.result)});
}

window.updateOtpResult = function updateOtpResult(result) {
  apolloClient.mutate({
    mutation: gql`
      mutation{
        passOtp(result: "${result}"){
          result,
          msg,
          token
        }
      }`,
  }).then((result) => { 
    console.log(result)
    if(result.data.passOtp.result=="failed"){
      alert(result.data.passOtp.msg)
    }
    if(result.data.passOtp.result=="passed"){
      window.location.href = '/auth_otp/'+result.data.passOtp.token
    }
  })
}

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()
let channel = socket.channel("room:"+ window.roomToken, {})
let messagesContainer = document.querySelector("#messages")
let chatForm = document.querySelector("#chatForm");
  chatForm.addEventListener("submit", (e) => {
      e.preventDefault();

      let chatInput = document.getElementById("chat-input");

      channel.push("new_msg", {body: chatInput.value})
      chatInput.value = ""
  });

channel.on("new_msg", payload => {
  messagesContainer.insertAdjacentHTML('beforeend', messageTemplate(payload))

  function messageTemplate(msg){
    let from = msg.from
    let body = msg.body

    return(`<li>
    <article
      tabindex="0"
      class="cursor-pointer border rounded-md p-3 bg-white flex text-gray-700 mb-2 hover:border-green-500 focus:outline-none focus:border-green-500"
    >
      <span class="flex-none pt-1 pr-2">
        <img
          class="h-8 w-8 rounded-md"
          src="https://raw.githubusercontent.com/bluebrown/tailwind-zendesk-clone/master/public/assets/avatar.png"
        />
      </span>
      <div class="flex-1">
        <header class="mb-1">${from} wrote:</header>
        <p class="text-gray-600">${body}</p>
      </div>
    </article>
    </li>`)
  }
})



channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })