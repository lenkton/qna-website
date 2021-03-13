document.addEventListener('turbolinks:load', function(event){
  if(answers = document.getElementById('answers'))
    answers.addEventListener('click', function(answersEvent){
      if(answersEvent.target.classList.contains('edit-answer-button'))
        showEditForm(answersEvent)
      if(answersEvent.target.classList.contains('edit-answer-cancel'))
        hideEditForm(answersEvent)
    })
})

function showEditForm(e){
  e.preventDefault()
  let answerId = e.target.dataset.answerId
  document.getElementById('answer-' + answerId + '-edit-form').classList.remove('hidden')
  document.getElementById('answer-' + answerId + '-body').classList.add('hidden')
}

function hideEditForm(e){
  e.preventDefault()
  let answerId = e.target.dataset.answerId
  document.getElementById('answer-' + answerId + '-edit-form').classList.add('hidden')
  document.getElementById('answer-' + answerId + '-body').classList.remove('hidden')
}
