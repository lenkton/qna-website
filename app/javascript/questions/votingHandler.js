document.addEventListener('turbolinks:load', addHandler)

function addHandler() {
  if(ratingSection = document.getElementById('question-rating')) ratingSection.addEventListener('ajax:success', successHandler)
}

function successHandler(event) {
  let answer = event.detail[0]

  switch(answer.question.vote.status) {
    case 'created':
      handleNewVote(answer, this)
      break;
    case 'deleted':
      handleDeletedVote(answer, this)
      break;
  }
}

function handleDeletedVote(answer, ratingSection) {
  ratingSection.classList.remove('voted')

  let ratingValue = Number(ratingSection.querySelector('.rating-value').innerHTML)
  ratingValue += answer.question.vote.previous_value ? -1 : 1
  ratingSection.querySelector('.rating-value').innerHTML = ratingValue
}

function handleNewVote(answer, ratingSection) {
  let ratingValue = Number(ratingSection.querySelector('.rating-value').innerHTML)
  ratingValue += answer.question.vote.supportive ? 1 : -1
  ratingSection.querySelector('.rating-value').innerHTML = ratingValue

  fixCancelLink(ratingSection, answer.question.vote.id)

  ratingSection.classList.add('voted')
}

function fixCancelLink(place, voteId) {
  place.querySelector('.vote-cancel a').href = '/votes/' + voteId
}
