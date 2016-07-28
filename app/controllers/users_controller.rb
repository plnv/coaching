class UsersController < ApplicationController
  # Before filters
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = I18n.t('flash.messages.welcome')
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      #flash[:success] = "Profile updated"
      flash[:success] = I18n.t('flash.messages.profile_updated')
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find_by(id:params[:id])
    if @user
      @user.destroy
      flash[:success] = I18n.t('flash.messages.user_deleted')
    else
      flash[:danger] = I18n.t('flash.messages.user_not_exist')
    end
    redirect_to users_url
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        #flash[:danger] = "Please log in."
        flash[:danger] = I18n.t("flash.messages.log_in")
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
