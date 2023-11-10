module Users
  class SessionOtpsController < ApplicationController
    layout 'devise'

    before_action :validate_session_otp_user_id, only: %i[new create]

    def new; end

    def create
      if @user.validate_and_consume_otp!(params[:user][:otp_attempt])
        session[:otp_user_id] = nil

        sign_in(@user)

        redirect_to root_path
      else
        flash[:danger] = "Invalid OTP code"

        redirect_to new_user_sign_in_otp_path
      end
    end

    private

    def validate_session_otp_user_id
      return redirect_to new_user_session_path if session[:otp_user_id].blank?

      @user = User.find(session[:otp_user_id])
    end
  end
end