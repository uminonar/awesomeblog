class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page], per_page: 15)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      log_in @user

      flash[:success] = "Welcome to Awesome Blog App"
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page], per_page: 15)
  end

  def edit
     @user = User.find(params[:id])
  end

  def update
    # @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      flash[:success] = "Updated your information successfully."
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    flash[:info] = "Successfully delete user: #{user.email}"
    user.destroy

    redirect_to users_url
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Only current user can access
    def correct_user
      @user = User.find(params[:id])

      unless current_user?(@user)
        flash[:danger] = "You are not allowed here."
        redirect_to root_url
      end
    end

    # Only admin user can access
    def admin_user
      unless current_user.admin?
        flash[:danger] = "You are not allowed to do that."
        redirect_to root_url
      end
    end
end