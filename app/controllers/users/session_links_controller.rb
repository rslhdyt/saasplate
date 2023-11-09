module Users
  class SessionLinksController < ApplicationController
    layout 'devise'

    def new
      @user = User.new
    end

    def create
      @user = User.find_by(email: params[:user][:email])

      if @user.present?
        UserServices::LoginLink.call(@user)

        redirect_to new_user_session_path, notice: 'A temporary login code has been sent to your inbox. Please check it.'
      else
        @user = User.new
        flash[:notice] = 'Email address not found. Please try again.'

        render :new, status: :unprocessable_entity
      end
    end

    def authenticate
      @user = User.find_signed(params[:token], purpose: :magic_link)

      if @user.present?
        sign_in(@user)

        flash[:success] = 'You have successfully logged in.'

        redirect_to root_path
      else
        flash[:info] = 'Link invalid or expired. Please try again.'

        redirect_to new_user_session_path
      end
    end
  end
end