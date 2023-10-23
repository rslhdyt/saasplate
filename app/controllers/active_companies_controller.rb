class ActiveCompaniesController < ApplicationController
  before_action :authenticate_user!

  def update
    active_company = current_user.user_companies.find_by(company_id: params[:company_id])

    if active_company.present?
      current_user.active_company_id = params[:company_id]
      current_user.save!
    end

    redirect_to root_path, notice: I18n.t('pages.welcome')
  end
end
