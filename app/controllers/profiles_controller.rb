class ProfilesController < SettingsController
  def show
    @user = current_user

    @auth_providers = {}
    @user.auth_providers.each do |provider|
      @auth_providers[provider.name.downcase] = { id: provider.id }
    end
  end

  def edit
    @user = current_user
  end

  def update
    if current_user.update(profile_params)
      redirect_to profile_path, notice: I18n.t('pages.profiles.update')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:name, :phone_number)
  end
end
