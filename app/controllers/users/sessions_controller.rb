# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    prepend_before_action :check_captcha, only: [:create]

    # POST /sign_in
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

    private
    
    def check_captcha
      v3_verify = verify_recaptcha(action: 'login', 
                                 minimum_score: 0.7, 
                                 secret_key: ENV['RECAPTCHA_SECRET_KEY'])
      v2_verify = verify_recaptcha(secret_key: ENV['RECAPTCHA_SECRET_KEY_V2'])

      return if v3_verify || v2_verify
      
      self.resource = resource_class.new sign_in_params
      
      respond_with_navigational(resource) { render :new }
    end

    protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
    def after_sign_out_path_for(_resource_or_scope)
      new_user_session_path
    end
  end
end
