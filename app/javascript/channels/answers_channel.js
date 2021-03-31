import consumer from "./consumer"
import { connectToCommentsChannel } from './comments_channel'

document.addEventListener('turbolinks:load', updateCables)

let oldSubscription


function updateCables() {
  let question = document.getElementById('question')
  if (question) connectToAnswersChannel(question.dataset.id)
}

function connectToAnswersChannel(id) {
  if (oldSubscription) oldSubscription.unsubscribe()

  oldSubscription = consumer.subscriptions.create({ channel: "AnswersChannel", question_id: id }, {
    received(data) {
      if (data.answer) addAnswer(data)
    }
  })
}

function addAnswer(answerData) {
  let answersList = document.getElementById('answers')
  
  if(!answersList) return

  let answerTemplate = require('../templates/answer.hbs')
  let user = document.getElementById('user')
  answerData.user = user

  answerData.author = (user && user.dataset.id == answerData.answer.author_id)

  answersList.insertAdjacentHTML('beforeend', answerTemplate(answerData))
  connectToCommentsChannel(answerData.answer.id, 'Answer')
}
