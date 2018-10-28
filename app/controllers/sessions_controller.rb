class SessionsController < ApplicationController
  layout 'sessions'
  skip_before_action :redirect_to_new_session_path, only: [:new, :create]
  before_action :redirect_to_root, only: [:new, :create], if: :session_exists?

  def new
    @session = Session.new
  end

  def create
    @session = Session.new session_params

    if @session.save
      success :welcome, @session.user.first_name
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    @session.destroy
    info :you_have_been_logged_out
    redirect_to new_session_path
  end

  private

  def session_params
    params.require(:session).permit :email, :password
  end
end
