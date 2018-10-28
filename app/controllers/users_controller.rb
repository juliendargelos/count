class UsersController < ApplicationController
  skip_before_action :redirect_to_new_user_path, only: [:new, :create]
  skip_before_action :redirect_to_new_session_path, only: [:new, :create]
  before_action(only: [:new, :create]) { redirect_to_new_session_path if !session_exists? && user_any? }
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def edit

  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      if User.count == 1
        Session.new(user_params.permit(:email, :password)).save
        success :welcome, @user.first_name
        redirect_to root_path
      else
        success :user_created
        redirect_to users_path
      end
    else
      error :could_not_create_user
      render :new
    end
  end

  def update
    if @user.update user_params
      success :user_saved
      redirect_to users_path
    else
      error :cound_not_save_user
      render :edit
    end
  end

  def destroy
    if User.count <= 1
      error :the_application_requires_at_least_one_user
    else
      if @user.destroy
        info :user_deleted
      else
        error :could_not_delete_user
      end

      redirect_to users_path
    end
  end

  protected

  def resolve_layout
    user_any? ? super : 'sessions'
  end

  private

  def set_user
    @user = User.find params[:id]
  end

  def user_params
    params.require(:user).permit :first_name, :last_name, :email, :phone, :password, :password_confirmation
  end
end
