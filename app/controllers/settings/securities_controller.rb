module Settings
  class SecuritiesController < SettingsController
    def show
      @user = current_user
    end

    def update
      @user = current_user

      if @user.valid_password?(security_params[:old_password])
        @user.update(password: security_params[:password])

        flash[:success] = 'Password successfully updated.'

        redirect_to settings_security_path
      else
        redirect_to settings_security_path, alert: 'Old password is incorrect.'
      end
    end

    private

    def security_params
      params.require(:user).permit(:old_password, :password, :password_confirmation)
    end
  end
end
