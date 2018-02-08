# TaskController
#
class TasksController < ApplicationController
  before_action :task_find, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all.order(created_at: 'desc')
    @page_title = t('title_index', title: Task.model_name.human)
  end

  def show
    @page_title = t('title_show', title: Task.model_name.human)
  end

  def new
    @task = Task.new
    @page_title = t('title_new', title: Task.model_name.human)
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path
      flash[:success] = t('flash.create_success', target: Task.model_name.human)
    else
      @page_title = t('title_new', title: Task.model_name.human)
      render new_task_path
    end
  end

  def edit
    @page_title = t('title_edit', title: Task.model_name.human)
  end

  def update
    if @task.update(task_params)
      flash[:success] = t('flash.update_success', target: Task.model_name.human)
      redirect_to task_path @task
    else
      flash[:failed] = t('flash.update_failed', target: Task.model_name.human)
      render :edit
    end
    @page_title = t('title_edit', title: Task.model_name.human)
  end

  def destroy
    @task.destroy
    flash[:success] = t('flash.destroy_success', target: Task.model_name.human)
    redirect_to tasks_path
  end


  private

    def task_find
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:name, :description, :status, :priority, :started_on, :ended_on)
    end
end
