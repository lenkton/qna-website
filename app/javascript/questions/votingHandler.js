document.addEventListener('turbolinks:load', addHandler)

function addHandler() {
  if(ratingSection = document.getElementById('question-rating')) ratingSection.addEventListener('ajax:success', successHandler)
}

function successHandler(event) {
  let answer = event.detail[0]
  let ratingValue = Number(this.querySelector('.rating-value').innerHTML)
  ratingValue += answer.supportive ? 1 : -1
  this.querySelector('.rating-value').innerHTML = ratingValue

  this.classList.add('voted')
}
