document.addEventListener('turbolinks:load', addHandlers)

function addHandlers() {
  if(ratingSection = document.getElementById('question-rating')) ratingSection.addEventListener('ajax:success', successQuestionHandler)
  if(answersSection = document.getElementById('answers')) answersSection.addEventListener('ajax:success', successAnswersHandler)
}

function successAnswersHandler(event) {
  successHandler(
    event.detail[0].answer.vote,
    event.target.closest('.rating')
  )
}

function successQuestionHandler(event) {
  successHandler(
    event.detail[0].question.vote,
    this
  )
}

function successHandler(vote, section) {

  switch(vote.status) {
    case 'created':
      handleNewVote(vote, section)
      break
    case 'deleted':
      handleDeletedVote(vote, section)
      break
  }
}

function handleDeletedVote(vote, ratingSection) {
  ratingSection.classList.remove('voted')

  let ratingValue = Number(ratingSection.querySelector('.rating-value').innerHTML)
  ratingValue -= vote.previous_value
  ratingSection.querySelector('.rating-value').innerHTML = ratingValue
}

function handleNewVote(vote, ratingSection) {
  let ratingValue = Number(ratingSection.querySelector('.rating-value').innerHTML)
  ratingValue += vote.value
  ratingSection.querySelector('.rating-value').innerHTML = ratingValue

  fixCancelLink(ratingSection, vote.id)

  ratingSection.classList.add('voted')
}

function fixCancelLink(place, voteId) {
  place.querySelector('.vote-cancel a').href = '/votes/' + voteId
}
