module Settings
  class TwoFasController < SettingsController
    def edit
      label = current_user.email
      issuer = Rails.configuration.application_name
      
      if current_user.otp_secret.nil?
        current_user.update(otp_secret: User.generate_otp_secret)
      end

      @totp = current_user.otp_secret
      @profisioning_url = current_user.otp_provisioning_uri(label, issuer: issuer)
    end

    def update
      if current_user.validate_and_consume_otp!(params[:otp_attempt])
        current_user.update(otp_required_for_login: true)

        redirect_to settings_security_path, notice: 'Two factor authentication enabled.'
      else
        flash[:danger] = 'Invalid two factor authentication code.'

        redirect_to edit_settings_two_fa_path
      end
    end
    
    def destroy
      current_user.update(otp_required_for_login: false)
      redirect_to settings_security_path, notice: 'Two factor authentication disabled.'
    end
  end
end