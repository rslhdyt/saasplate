module Settings
  class AuthProvidersController < ApplicationController
    def destroy
      @auth_provider = current_user.auth_providers.find(params[:id])
      @auth_provider.destroy

      redirect_to profile_path, notice: "Successfully removed authentication method."
    end
  end
end