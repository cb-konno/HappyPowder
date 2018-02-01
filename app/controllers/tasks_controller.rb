# encoding: utf-8
class TasksController < ApplicationController

  before_action :page_title_creation, only: [:index, :show, :edit, :new]
  before_action :task_find, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all.order(created_at: 'desc')
  end

  def show
  end

  def new
    @task = Task.new
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

    def page_title_creation
      if params[:action] == 'index'
        @page_title = 'タスク一覧'
      elsif params[:action] == 'edit'
        @page_title = 'タスク編集'
      elsif params[:action] == 'new'
        @page_title = 'タスク新規作成'
      elsif params[:action] == 'show'
        @page_title = 'タスク詳細'
      else
        @page_title = ''
      end
    end

    def task_params
      params.require(:task).permit(:name, :description, :status, :priority, :started_at, :ended_at)
    end

end
