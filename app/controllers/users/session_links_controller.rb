module Users
  class SessionLinksController < ApplicationController
    layout 'devise'

    def new
      @user = User.new
    end

    def create
      @user = User.find_by(email: params[:user][:email])

      flash[:notice] = 'A temporary login code has been sent to your inbox. Please check it.'

      if @user.present?
        UserServices::LoginLink.call(@user)

        redirect_to new_user_session_path
      else
        @user = User.new

        render :new, status: :unprocessable_entity
      end
    end

    def authenticate
      @user = User.find_signed(params[:token], purpose: :magic_link)

      if @user.present?
        if resource.otp_required_for_login?
          session[:otp_user_id] = @user.id

          redirect_to new_user_session_otp_path
        else
          flash[:success] = 'You have successfully logged in.'

          sign_in(@user)

          redirect_to root_path
        end
      else
        flash[:info] = 'Link invalid or expired. Please try again.'

        redirect_to new_user_session_path
      end
    end

    private

    def redirect_after_sign_in_path
      if @user.admin?
        admin_root_path
      else
        root_path
      end
    end
  end
end