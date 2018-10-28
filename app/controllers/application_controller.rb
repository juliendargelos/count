class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # handles_not_found_status and handles_error_status
  default_form_builder SimpleForm::FormBuilder
  before_action :set_session
  layout :resolve_layout
  before_action :redirect_to_new_user_path, unless: :user_any?
  before_action :redirect_to_new_session_path, unless: :session_exists?
  before_action :set_locale_to_default

  protected

  def resolve_layout
    frame? ? false : 'application'
  end

  def success(*message)
    notificate :success, *message
  end

  def info(*message)
    notificate :info, *message
  end

  def warning(*message)
    notificate :warning, *message
  end

  def error(*message)
    notificate :error, *message
  end

  def notificate(type, *message)
    message = message.join ' '
    notifications(:keep) << [type, t(message, default: message.humanize)]
  end

  def notifications(keep = false)
    session[:notifications] ||= []
    notifications = session[:notifications]
    session.delete :notifications unless keep
    notifications
  end
  helper_method :notifications

  def set_session
    Session.store = session
    @session = Session.current
  end

  def set_locale_to_default
    I18n.locale = I18n.default_locale
  end

  def frame?
    params.key? :frame
  end
  helper_method :frame?

  def redirect_to_root
    redirect_to root_path
  end

  def redirect_to_new_user_path
    redirect_to new_user_path
  end

  def redirect_to_new_session_path
    redirect_to new_session_path
  end

  def user_any?
    User.count != 0
  end

  def session_exists?
    @session.exists?
  end
end
