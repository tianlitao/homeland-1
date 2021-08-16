# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :require_no_sso!, only: %i[new create]

  def unipass_login
    back_data = JSON.parse params['unipass_ret'] rescue {}
    if back_data['code'] != 200
      set_flash_message(:alert, 'Sign in and bind Unipass account failed.')
    end
    if user = User.find_or_create_for_unipass(back_data['data'])
      set_flash_message(:notice, "Sign in successfully with bind #{Homeland::Utils.omniauth_name('unipass')}")
      sign_in(user)
    else
      set_flash_message(:alert, 'Sign in and bind Unipass account failed.')
    end
    redirect_to root_path
  end
  
  def create
    resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?

    if session[:omniauth]
      @auth = Authorization.find_or_create_by!(provider: session[:omniauth]["provider"], uid: session[:omniauth]["uid"], user_id: resource.id)
      if @auth.blank?
        redirect_to new_user_session_path, alter: "Sign in and bind OAuth account failed."
        return
      end

      set_flash_message(:notice, "Sign in successfully with bind #{Homeland::Utils.omniauth_name(session[:omniauth]["provider"])}")
      session[:omniauth] = nil
    end

    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_to do |format|
      format.html { redirect_back_or_default(root_url) }
      format.json { render status: "201", json: resource.as_json(only: %i[login email]) }
    end
  end
end
