module Settings
  class SecuritiesController < ApplicationController
    layout 'settings'

    def show; end

    def edit_two_fa
      issuer = Rails.configuration.application_name
      label = "#{issuer}:#{current_user.email}"

      @profisioning_url = current_user.otp_provisioning_uri(label, issuer: issuer)
    end

    def update_two_fa
      if current_user.validate_and_consume_otp!(params[:otp_attempt])
        current_user.update(otp_required_for_login: true)

        redirect_to edit_settings_two_fa_path, notice: 'Two factor authentication enabled.'
      else
        flash[:danger] = 'Invalid two factor authentication code.'

        redirect_to edit_settings_two_fa_path
      end
    end
  end
end
