document.addEventListener('turbolinks:load', function(){
  let subscribeButton = document.getElementById('question-subscribe')
  if (subscribeButton) subscribeButton.addEventListener('ajax:success', subscriptionHandler)
  
  let unsubscribeButton = document.getElementById('question-unsubscribe')
  if (unsubscribeButton) unsubscribeButton.addEventListener('ajax:success', unsubscriptionHandler)
})

function subscriptionHandler(event) {
  showSuccessMessage()
  subscribdize()
  fixUnsubPath(event)
}

function unsubscriptionHandler() {
  showSuccessUnsubMessage()
  unsubscribdize()
}

function showSuccessMessage() {
  document.getElementById('notice').innerHTML = 'Вы успешно подписаны на рассылку!'
}

function showSuccessUnsubMessage() {
  document.getElementById('notice').innerHTML = 'Вы успешно отписались от рассылки!'
}

function subscribdize() {
  document.getElementById('question-subscribe-block').classList.add('subscribed')
}

function unsubscribdize() {
  document.getElementById('question-subscribe-block').classList.remove('subscribed')
}

function fixUnsubPath(event) {
  document.getElementById('question-unsubscribe-link').href = '/subscribings/' + event.detail[0].subscribing.id
}
