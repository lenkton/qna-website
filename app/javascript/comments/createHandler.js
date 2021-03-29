document.addEventListener('turbolinks:load', addHandlers)

function addHandlers() {
  if(commentsSection = document.getElementById('question')) {
    commentsSection.addEventListener('ajax:success', successHandler)
    commentsSection.addEventListener('ajax:error', errorHandler)
  }
  if(answersSection = document.getElementById('answers')) {
    answersSection.addEventListener('ajax:success', successHandler)
    answersSection.addEventListener('ajax:error', errorHandler)
  }
}

function successHandler(event) {
  commentData = event.detail[0].comment
  if(!commentData) return

  document.getElementById(entityPrefixUnderscore(commentData) + '_comment_text').value = ''
  document.getElementById(entityPrefix(commentData) + '-comment-errors').innerHTML = ''
}


function errorHandler(event) {
  commentData = event.detail[0].comment
  errors = event.detail[0].errors
  if(!commentData || !errors ) return

  errorsTemplate = require('../templates/errors.hbs')
  document.getElementById(entityPrefix(commentData) + '-comment-errors').innerHTML = errorsTemplate({errors: errors})
}

function entityPrefix(commentData) {
  switch(commentData.commentable_type){
    case 'Answer':
      return 'answer-' + commentData.commentable_id
    case 'Question':
      return 'question'
  }
}

function entityPrefixUnderscore(commentData) {
  switch(commentData.commentable_type){
    case 'Answer':
      return 'answer_' + commentData.commentable_id
    case 'Question':
      return 'question'
  }
}
