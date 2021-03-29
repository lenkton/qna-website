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
      if (data.answer) addAnswer(data)
      if (data.comment) addComment(data)
    }
  })
}

function addComment(commentData) {
  switch(commentData.comment.commentable_type){
    case "Question":
      addCommentInto(commentData, 'question-comments')
      break
    case "Answer":
      addCommentInto(commentData, 'answer-' + commentData.comment.commentable_id + '-comments')
      break
  }
}

function addCommentInto(commentData, listId) {
  let commentList = document.getElementById(listId)

  if(!commentList) return

  let commentTemplate = require('../templates/comment.hbs')
  commentList.insertAdjacentHTML('beforeend', commentTemplate(commentData))
}

function addAnswer(answerData) {
  let answersList = document.getElementById('answers')
  
  if(!answersList) return

  let answerTemplate = require('../templates/answer.hbs')
  let user = document.getElementById('user')
  answerData.user = user

  answerData.author = (user && user.dataset.id == answerData.answer.author_id)

  answersList.insertAdjacentHTML('beforeend', answerTemplate(answerData))
}
