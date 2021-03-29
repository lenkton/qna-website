import consumer from "./consumer"

document.addEventListener('turbolinks:load', updateCables)

let oldSubscription

function updateCables() {
  let question = document.getElementById('question')
  if (question) connectToQuestionChannel(question.dataset.id)
}

function connectToQuestionChannel(id) {
  if (oldSubscription) oldSubscription.unsubscribe()

  oldSubscription = consumer.subscriptions.create({ channel: "QuestionChannel", question_id: id }, {
    received(data) {
      addAnswer(data)
    }
  })
}

function addAnswer(answerData) {
  let answersList = document.getElementById('answers')
  
  if(!answersList || !answerData.answer) return

  let answerTemplate = require('../templates/answer.hbs')
  let user = document.getElementById('user')
  answerData.user = user

  answerData.author = (user && user.dataset.id == answerData.answer.author_id)

  answersList.insertAdjacentHTML('beforeend', answerTemplate(answerData))
}
