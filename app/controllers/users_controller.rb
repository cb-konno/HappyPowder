# UserController
#
class UsersController < ApplicationController

  def index
    @users = User.ransack(params[:q]).result
    @page_title = t('title_index', title: User.model_name.human)
  end

end
