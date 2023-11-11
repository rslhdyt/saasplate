# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    # before_action :configure_sign_in_params, only: [:create]

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    def create
      self.resource = User.find_by(email: params[:user][:email])

      if resource && resource.valid_password?(params[:user][:password])
        if resource.otp_required_for_login?
          session[:otp_user_id] = resource.id
          sign_out(:user)

          redirect_to new_user_session_otp_path
        else
          set_flash_message!(:success, :signed_in)
          sign_in(resource_name, resource)

          respond_with resource, location: after_sign_in_path_for(resource)
        end
      else
        flash[:danger] = 'Invalid email or password.'

        redirect_to new_user_session_path
      end
    end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
    def after_sign_out_path_for(_resource_or_scope)
      new_user_session_path
    end
  end
end