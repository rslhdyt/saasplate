# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    prepend_before_action :authenticate_scope!, only: [:edit, :update, :destroy, :new_company, :create_company]
    before_action :configure_sign_up_params, only: [:create]
    before_action :check_registration_enabled, only: [:new, :create]

    # before_action :configure_account_update_params, only: [:update]

    # GET /resource/sign_up
    # def new
    #   super
    # end

    # POST /resource
    # def create
    #   super
    # end

    # GET /resource/edit
    # def edit
    #   super
    # end

    # PUT /resource
    # def update
    #   super
    # end

    # DELETE /resource
    # def destroy
    #   super
    # end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end

    def new_company
      @company = current_user.companies.new
    end

    def create_company
      ActiveRecord::Base.transaction do
        @company = current_user.companies.new(company_params)
        current_user.user_companies.create(company: @company)
        current_user.update(active_company: @company)
      end

      redirect_to root_path, notice: 'Company was successfully created.'
    end

    protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up) do |user_params|
        user_params.permit(:name, :email, :password, :password_confirmation)
      end
    end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_account_update_params
    #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
    # end

    # The path used after sign up.
    def after_sign_up_path_for(resource)
      sign_in(resource)

      flash[:notice] = "Welcome to the app! Let's get started by creating your company."

      new_company_registration_path
    end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end

    # Only allow a list of trusted parameters through.
    def company_params
      params.require(:company).permit(:name, :email)
        .merge(owner_id: current_user.id)
    end

    private

    def check_registration_enabled
      return if AppConfig.register_enable?

      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end
end
