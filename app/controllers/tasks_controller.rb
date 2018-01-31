class TasksController < ApplicationController
  def index
    @tasks = Task.all.order(created_at: 'desc')
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
  end

  def create
    @task = Task.new(params.require(:task).permit(:name, :description, :status, :priority, :started_at, :ended_at))
    @task.save

    redirect_to tasks_path
    flash[:success] = "New Task Created."
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(params.require(:task).permit(:name, :description, :status, :priority, :started_at, :ended_at))
      flash[:success] = "Task Updated Success."
      redirect_to task_path @task
    else
      flash[:failed] = "Task Updated Failed."
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    flash[:success] = "Task Deleted."
    redirect_to tasks_path
  end

end
