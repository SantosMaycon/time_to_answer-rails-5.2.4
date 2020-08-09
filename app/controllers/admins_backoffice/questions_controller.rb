class AdminsBackoffice::QuestionsController < AdminsBackofficeController
  before_action :set_question, only: [:edit, :update, :destroy]
  before_action :set_subject_options, only: [:new, :create, :edit, :update] 
  
  def index
    @questions = Question.includes(:subject).order(:description).page(params[:page]).per(5)
  end

  def edit
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(params_question)

    if @question.save
      redirect_to admins_backoffice_questions_path, notice: "Saved with success !!"
    else
      render :new
    end    
  end

  def update
    if @question.update(params_question)
      redirect_to admins_backoffice_questions_path, notice: "Updated with success !!"
    else
      render :edit
    end
  end

  def destroy
    if @question.destroy
      redirect_to admins_backoffice_questions_path, notice: "Deleted with success !!"
    else
      render :index
    end
  end

  private
  def set_subject_options
    @subject_options = Subject.all.pluck(:description, :id)
  end
  def set_question
    @question = Question.find(params[:id])
  end
  def params_question
    params.require(:question).permit(:description, :subject_id)
  end
end
  