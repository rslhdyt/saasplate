# frozen_string_literal: true

module Users
  class InvitationsController < ApplicationController
    before_action :authenticate_user!, except: %i[accept]

    before_action :set_user_company, only: %i[edit update destroy]

    def index
      @user_companies = current_active_company
          .user_companies
          .invitation_not_accepted
          .page(params[:page])
          .per(params[:limit])
    end

    def new
      @user = Users::InvitationForm.new(current_user)
    end

    def edit; end

    def create
      @user = Users::InvitationForm.new(current_user, invite_params)

      respond_to do |format|
        if @user.save
          format.html { redirect_to users_invitations_path, notice: "User invitation was successfully sent." }
          format.json { render :show, status: :created, location: @user }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    def accept
      invitation = UserServices::AcceptInvitation.call(params[:invitation_token])

      if invitation.password_token.present?
        redirect_to edit_user_password_path(reset_password_token: invitation.password_token), notice: I18n.t('pages.invitations.setup_password')
      else
        redirect_to new_user_session_path, notice: I18n.t('pages.invitations.accepted')
      end
    rescue UserServices::AcceptInvitation::Errors => e
      redirect_to new_user_session_path, flash: { error: e.message }
    end

    def update
      if @user_company.user.update!(update_params.except(:role))
        @user_company.update(role: update_params[:role])

        # UserServices::Invite.call(current_user, {
        #   email: @user_company.user_email
        # })

        redirect_to invitations_path, notice: I18n.t('pages.invitations.updated')
      else
        render :edit
      end
    end

    def resend
      @user_company = current_active_company.user_companies.find(params[:id])

      UserServices::ResendInvitation.call(@user_company)

      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = I18n.t('pages.invitations.sent') }
      end
    end

    def destroy
      @user_company = current_active_company.user_companies.find(params[:id])
      @user_company.destroy

      redirect_to invitations_path, notice: 'Invitation was successfully deleted.'
    end

    private

    def update_params
      invitation_params = params.require(:user_company).permit(:user_name, :user_email, :role)

      {
        name: invitation_params[:user_name],
        email: invitation_params[:user_email],
        role: invitation_params[:role]
      }
    end

    def invite_params
      params.require(:user).permit(:name, :email)
    end

    def set_user_company
      @user_company = current_active_company.user_companies.find(params[:id])
    end
  end
end
