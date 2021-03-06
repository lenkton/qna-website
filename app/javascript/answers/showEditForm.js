document.addEventListener('turbolinks:load', function(){
  let editButtons = document.querySelectorAll('.edit-answer-button')
  if (editButtons) editButtons.forEach(element => {
    element.addEventListener('click', showEditForm)
  });

  let cancels = document.querySelectorAll('.edit-answer-cancel')
  if (cancels) cancels.forEach(element => {
    element.addEventListener('click', hideEditForm)
  });
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
