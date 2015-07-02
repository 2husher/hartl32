class UsersController < ApplicationController
  before_filter :signed_in_user,    only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,      only: [:edit, :update]
  before_filter :admin_user,        only: :destroy
  before_filter :already_signed_in, only: [:new, :create]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      redirect_to @user, flash: { success: "Welcome to the Sample App!" }
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
      sign_in @user
      redirect_to @user, flash: { success: "Profile updated" }
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    unless current_user?(user)
      user.destroy
      redirect_to users_url, flash: { success: "User destroyed." }
    else
      redirect_to root_url, notice: "You can't delete youself"
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def signed_in_user
      store_location
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def already_signed_in
      redirect_to(root_url) if signed_in?
    end
end
