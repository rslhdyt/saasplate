module Settings
  class TwoFasController < SettingsController
    def edit
      issuer = Rails.configuration.application_name
      label = current_user.email

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