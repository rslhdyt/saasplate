class ApplicationController < ActionController::Base
  add_flash_types :info, :error, :warning

  before_action :user_has_company?

  delegate :current_active_company, to: :helpers

  def user_has_company?
    return if %w[sessions].include?(controller_name)

    return unless current_user && current_user_companies_active.blank?
    return if current_active_company.present?

    redirect_to new_company_path, notice: 'You need to create a company first.'
  end

  def current_user_companies_active
    Rails.cache.fetch("current_user_companies_active:#{current_user.id}", skip_nil: true, expires_in: 1.hour) do
      current_user.user_companies.last
    end
  end
end
