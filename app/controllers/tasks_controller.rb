# TaskController
#
class TasksController < ApplicationController
  before_action :task_find, only: [:show, :edit, :update, :destroy]

  ALLOWED_SORT_COLUMN = ['ended_on', 'ended_on desc', 'created_at', 'created_at desc'].freeze

  def index
    sort = params[:sort] if ALLOWED_SORT_COLUMN.include?(params[:sort])
    @tasks = Task.all.order(sort)
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
      flash[:success] = t('flash.create_success', target: Task.model_name.human)
      redirect_to tasks_path
    else
      @page_title = t('title_new', title: Task.model_name.human)
      render :new
    end
  end

  def edit
    @page_title = t('title_edit', title: Task.model_name.human)
  end

  def update
    if @task.update(task_params)
      flash[:success] = t('flash.update_success', target: Task.model_name.human)
      @page_title = t('title_show', title: Task.model_name.human)
      redirect_to task_path @task
    else
      flash[:failed] = t('flash.update_failed', target: Task.model_name.human)
      @page_title = t('title_edit', title: Task.model_name.human)
      render :edit
    end
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
