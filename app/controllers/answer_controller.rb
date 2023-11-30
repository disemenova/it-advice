class AnswerController < ApplicationController
  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_user!, unless: :user_signed_in?

  def save
    answer = Answer.find(params[:answer_id])
    UserAnswer.create do |user_answer|
      user_answer.user_id = current_user.id
      user_answer.answer_id = answer.id
      user_answer.quiz_id = answer.question.quiz.id
      user_answer.question_id = answer.question.id
    end
    redirect_to controller: 'quizzes', action: 'show', id: answer.question.quiz.id
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope)
  end

  private

  def storable_location?
    request.get? &&
      is_navigational_format? &&
      !devise_controller? &&
      !request.xhr? # &&
    # !turbo_frame_request?
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end
end
