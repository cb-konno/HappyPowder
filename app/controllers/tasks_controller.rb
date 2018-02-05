# TaskController
#
class TasksController < ApplicationController
  before_action :task_find, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all.order(created_at: 'desc')
    @page_title = 'タスク一覧'
  end

  def show
    @page_title = 'タスク詳細'
  end

  def new
    @task = Task.new
    @page_title = 'タスク新規作成'
  end

  def create
    @task = Task.new(task_params)
    @task.save

    redirect_to tasks_path
    flash[:success] = 'New Task Created.'
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'Task Updated Success.'
      redirect_to task_path @task
    else
      flash[:failed] = 'Task Updated Failed.'
      render :edit
    end
    @page_title = 'タスク編集'
  end

  def destroy
    @task.destroy
    flash[:success] = 'Task Deleted.'
    redirect_to tasks_path
  end


  private

    def task_find
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:name, :description, :status, :priority, :started_at, :ended_at)
    end
end
