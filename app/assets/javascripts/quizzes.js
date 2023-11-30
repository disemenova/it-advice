document.addEventListener("DOMContentLoaded", function() {
    const addQuestionButton = document.getElementById("add_question");
    const questionsContainer = document.getElementById("questions");

    let questionIndex = 1;

    addQuestionButton.addEventListener("click", function() {
        const questionHTML = `
      <div class="question">
        <label for="quiz_questions_attributes_${questionIndex}_number">Номер вопроса</label>
        <input type="number" name="quiz[questions_attributes][${questionIndex}][number]" id="quiz_questions_attributes_${questionIndex}_number">

        <label for="quiz_questions_attributes_${questionIndex}_name">Текст вопроса</label>
        <input type="text" name="quiz[questions_attributes][${questionIndex}][name]" id="quiz_questions_attributes_${questionIndex}_name">

        <h3>Ответы:</h3>

        <label for="quiz_questions_attributes_${questionIndex}_answers_attributes_0_content">Ответ 1</label>
        <input type="text" name="quiz[questions_attributes][${questionIndex}][answers_attributes][0][content]" id="quiz_questions_attributes_${questionIndex}_answers_attributes_0_content">

        <label for="quiz_questions_attributes_${questionIndex}_answers_attributes_1_content">Ответ 2</label>
        <input type="text" name="quiz[questions_attributes][${questionIndex}][answers_attributes][1][content]" id="quiz_questions_attributes_${questionIndex}_answers_attributes_1_content">

        <label for="quiz_questions_attributes_${questionIndex}_answers_attributes_2_content">Ответ 3</label>
        <input type="text" name="quiz[questions_attributes][${questionIndex}][answers_attributes][2][content]" id="quiz_questions_attributes_${questionIndex}_answers_attributes_2_content">

        <label for="quiz_questions_attributes_${questionIndex}_answers_attributes_3_content">Ответ 4</label>
        <input type="text" name="quiz[questions_attributes][${questionIndex}][answers_attributes][3][content]" id="quiz_questions_attributes_${questionIndex}_answers_attributes_3_content">
      </div>
    `;

        questionsContainer.insertAdjacentHTML("beforeend", questionHTML);

        questionIndex++;
    });
});