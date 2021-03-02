document.addEventListener('turbolinks:load', function(){
  let editButton = document.getElementById('question-edit-button')
  if (editButton) editButton.addEventListener('click', showEditForm)

  let cancel = document.getElementById('question-edit-cancel')
  if (cancel) cancel.addEventListener('click', hideEditForm)
})

function showEditForm(e){
  e.preventDefault()
  document.getElementById('question-edit-form').classList.remove('hidden')
  document.getElementById('question').classList.add('hidden')
}

function hideEditForm(e){
  e.preventDefault()
  document.getElementById('question-edit-form').classList.add('hidden')
  document.getElementById('question').classList.remove('hidden')
}
