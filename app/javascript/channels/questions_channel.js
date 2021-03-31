import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  received(data) {
    addQuestion(data)
  }
});

function addQuestion(questionData) {
  let questionList = document.getElementById('questions')
  
  if(!questionList || !questionData.id) return

  let a = document.createElement('A')
  a.href = '/questions/' + questionData.id
  a.innerText = questionData.title

  let li = document.createElement('LI')
  li.appendChild(a)

  questionList.appendChild(li)
}
