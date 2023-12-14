class QuizzesController < ApplicationController
  before_action :set_quiz, only: %i[ show edit update destroy ]
  protect_from_forgery prepend: true
  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_user!, unless: :user_signed_in?

  # GET /quizzes or /quizzes.json
  def index
    @quizzes = Quiz.all
  end

  # GET /quizzes/1 or /quizzes/1.json
  def show
    current_quiz = Quiz.find(params[:id])
    user_id = current_user.id
    if user_start_test? current_quiz.id, user_id
      # Получаем из теста номер вопроса, на который пользователь ответил последний раз
      last_question_number = UserAnswer
                                 .joins(:question)
                                 .where(user_id: user_id, quiz_id: current_quiz.id)
                                 .order("questions.number DESC")
                                 .first.question.number

      # Ищем id следующего вопроса
      next_question_number = last_question_number + 1
      last_question = Question.find_by(number: next_question_number, quiz_id: current_quiz.id)

      if last_question.nil?
        redirect_to action: 'result', id: current_quiz.id
        return
      else
        question_id = last_question.id
      end

    else
      question_id = Question.where(quiz_id: @current_quiz.id).order(number: :asc).first.id
    end
    redirect_to controller: 'question', action: 'show', id: question_id
  end

  def result
    @current_quiz = Quiz.find(params[:id])
    answer_ids = UserAnswer.where(user_id: current_user.id, quiz_id: @current_quiz.id).pluck(:answer_id)
    @answers = Answer.where(id: answer_ids).to_a
  end

  # GET /quizzes/new
  def new
    begin
    authorize Quiz
    rescue Pundit::NotAuthorizedError
      redirect_to quizzes_path, notice: 'У вас нет доступа к созданию тестов'
    end

    @quiz = Quiz.new
    @quiz.questions.build
    @quiz.questions.first.answers.build
  end
  # GET /quizzes/1/edit
  def edit
    begin
      authorize @current_quiz
    rescue Pundit::NotAuthorizedError
      redirect_to quizzes_path, notice: 'У вас нет доступа к изменению тестов'
    end
  end

  # POST /quizzes or /quizzes.json
  def create
    begin
      authorize Quiz
    rescue Pundit::NotAuthorizedError
      redirect_to quizzes_path, notice: 'У вас нет доступа к созданию тестов'
      return
    end

    @quiz = Quiz.new(quiz_params)

    if @quiz.save
      redirect_to @quiz, notice: 'Quiz успешно создан.'
    else
      render :new
    end
  end

  # PATCH/PUT /quizzes/1 or /quizzes/1.json
  def update
    begin
      authorize @current_quiz
    rescue Pundit::NotAuthorizedError
      redirect_to quizzes_path, notice: 'У вас нет доступа к изменению тестов'
      return
    end

    respond_to do |format|
      if @current_quiz.update(quiz_params)
        format.html { redirect_to quiz_url(@current_quiz), notice: "Quiz was successfully updated." }
        format.json { render :show, status: :ok, location: @current_quiz }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @current_quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quizzes/1 or /quizzes/1.json
  def destroy
    begin
      authorize @current_quiz
    rescue Pundit::NotAuthorizedError
      redirect_to quizzes_path, notice: 'У вас нет доступа к удалению тестов'
      return
    end

    @current_quiz.destroy!

    respond_to do |format|
      format.html { redirect_to quizzes_url, notice: "Quiz was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quiz
      @current_quiz = Quiz.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def quiz_params
      params.require(:quiz).permit(:name, :description, questions_attributes: [:id, :number, :name, answers_attributes: [:id, :content]])
    end

  def user_start_test?(quiz_id, user_id)
    UserAnswer.where(user_id: user_id, quiz_id: quiz_id).any?
  end

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
