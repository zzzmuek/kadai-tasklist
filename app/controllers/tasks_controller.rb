class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update] 
  before_action :require_user_logged_in, only: [:index, :show]
  before_action :correct_user, only: [:destroy]
  
  def index
    @tasks = current_user.task.order(id: :desc).page(params[:page])
  end
  
  def show
  end

  def new
    @task = current_user.task.build
  end

  def create
    @task = current_user.task.build(task_params)
    
    if @task.save
      flash[:success] = 'タスクが正常に登録されました'
      redirect_to tasks_url
    else
      @tasks = current_user.task.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'タスクが登録されませんでした'
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'タスクは正常に更新されました'
      redirect_to @task
    
    else
      flash.now[:danger] = 'タスクは更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task.destroy
    flash[:success] = 'タスクは正常に削除されました'
    redirect_to root_url
  end

  private
  
  def set_task
    @task = current_user.task.find(params[:id])
  end

  # Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end

  def correct_user
    @task = current_user.task.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end
