# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :auto_login_from_header, :unread_notifications, :set_self_hosted_status

  protected

  def default_url_options
    {}
  end

  def unread_notifications
    return [] unless current_user

    @unread_notifications ||= Notification.where(user: current_user).unread
  end

  def authenticate_admin!
    return if current_user&.admin?

    redirect_to root_path, notice: 'You are not authorized to perform this action.', status: :see_other
  end

  def authenticate_self_hosted!
    return if DawarichSettings.self_hosted?

    redirect_to root_path, notice: 'You are not authorized to perform this action.', status: :see_other
  end

  def authenticate_active_user!
    return if current_user&.active_until&.future?

    redirect_to root_path, notice: 'Your account is not active.', status: :see_other
  end

  def authenticate_non_self_hosted!
    return unless DawarichSettings.self_hosted?

    redirect_to root_path, notice: 'You are not authorized to perform this action.', status: :see_other
  end

  private

  def set_self_hosted_status
    @self_hosted = DawarichSettings.self_hosted?
  end
  
  def auto_login_from_header
    return if user_signed_in?

    username = request.headers['X-Remote-User-Name']
    return unless username.present?

    user = User.find_or_create_by(email: "#{username}@autologin.local") do |u|
      u.admin = true
      u.password = SecureRandom.hex(16) # Random password
    end

    sign_in(user)
  end
end

