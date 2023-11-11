class ProfilesController < ApplicationController
  layout 'settings'

  before_action :authenticate_user!

  def show; end

  def edit; end

  def update
    return render :edit unless current_user.update(profile_params)

    redirect_to profile_path, notice: I18n.t('pages.profiles.update')
  end

  private

  def profile_params
    params.require(:user).permit(:name, :phone_number)
  end
end