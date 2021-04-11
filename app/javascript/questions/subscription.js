document.addEventListener('turbolinks:load', function(){
  let subscribeButton = document.getElementById('question-subscribe')
  if (subscribeButton) subscribeButton.addEventListener('ajax:success', subscriptionHandler)
})

function subscriptionHandler(){
  showSuccessMessage()
  hideSubscribeButton()
}

function showSuccessMessage(){
  document.getElementById('notice').innerHTML = 'Вы успешно подписаны на рассылку!'
}

function hideSubscribeButton() {
  document.getElementById('question-subscribe').classList.add('hidden')
}
