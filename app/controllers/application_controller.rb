class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_current_user

  private

  def set_current_user
    if request.env["rodauth"]
      rodauth_instance = request.env["rodauth"]
      Current.account = rodauth_instance.logged_in? ? rodauth_instance.rails_account : nil
    else
      Current.account = nil
    end
  end

  def current_account
    Current.account
  end

  def rodauth
    request.env["rodauth"]
  end
end
