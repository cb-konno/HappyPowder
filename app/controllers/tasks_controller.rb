# TaskController
#
class TasksController < ApplicationController
  before_action :authenticate
  before_action :task_find, only: [:show, :edit, :update, :destroy]
  before_action :user_find_all, only: [:new, :create, :edit, :update]

  def index
    if params[:q].present?
      params[:q][:user_id_eq] = current_user.id if logged_in
    else
      params[:q] = { user_id_eq: current_user.id } if logged_in
    end

    @q = Task.ransack_with_check_params(params)
    @tasks = @q.result.includes(:user).page(params[:page]).per(5)
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
    def authenticate
      redirect_to login_path unless logged_in
    end

    def task_find
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:name, :description, :status, :priority, :started_on, :ended_on, :user_id)
    end

    def user_find_all
      @users = User.ransack(params[:q]).result
    end
end
