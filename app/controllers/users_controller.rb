# UserController
#
class UsersController < ApplicationController
  before_action :user_find, only: [:edit, :show, :update, :destroy]

  def index
    @q = User.ransack(params[:q])
    @users = @q.result.page(params[:page]).per(5)

    @page_title = t('title_index', title: User.model_name.human)
  end

  def new
    @user = User.new
    @page_title = t('title_new', title: User.model_name.human)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t('flash.create_success', target: User.model_name.human)
      redirect_to users_path
    else
      @page_title = t('title_new', title: User.model_name.human)
      render :new
    end
  end

  def show
    @page_title = t('title_show', title: User.model_name.human)
  end

  def edit
    @page_title = t('title_edit', title: User.model_name.human)
  end

  def update
    if @user.update(user_params)
      flash[:success] = t('flash.update_success', target: User.model_name.human)
      # @page_title = t('title_show', title: User.model_name.human)
      # redirect_to user_path @user
      @users = User.ransack(params[:q]).result
      @page_title = t('title_index', title: User.model_name.human)
      redirect_to users_path @users
    else
      flash[:failed] = t('flash.update_failed', target: User.model_name.human)
      @page_title = t('title_edit', title: User.model_name.human)
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t('flash.destroy_success', target: User.model_name.human)
    redirect_to users_path
  end

  private
    def user_find
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :mail, :password, :is_deleted)
    end
end
