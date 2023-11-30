class QuestionController < ApplicationController
  def show
    @current_question = Question.find(params[:id])
  end
end
