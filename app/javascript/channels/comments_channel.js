import consumer from "./consumer"

document.addEventListener('turbolinks:load', updateCables)

let oldSubscriptions = []

function updateCables() {
  if (oldSubscriptions) unsubscribeFromOld()

  connectToQuestionComments()
  connectToAnswersComments()
}

function unsubscribeFromOld() {
  oldSubscriptions.forEach(function(subscription) { subscription.unsubscribe() })
  oldSubscriptions = []
}

function connectToQuestionComments () {
  let question = document.getElementById('question')
  if (question) connectToCommentsChannel(question.dataset.id, 'Question')
}

function connectToAnswersComments () {
  let answers = document.getElementById('answers')
  if(answers) answers.querySelectorAll('.answer').forEach(function(answer){
    connectToCommentsChannel(answer.dataset.id, 'Answer')
  })
}

export function connectToCommentsChannel(id, type) {
  oldSubscriptions.push(
    consumer.subscriptions.create({ channel: "CommentsChannel", commentable_id: id, commentable_type: type }, {
      received(data) {
        if (data.comment) addComment(data)
      }
    })
  )
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
