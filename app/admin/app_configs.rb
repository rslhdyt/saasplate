ActiveAdmin.register AppConfig, as: 'Configuration' do
  actions :index, :new, :create

  config.remove_action_item :new

  action_item :new, only: :index do
    link_to 'Update Configuration', new_admin_configuration_path
  end

  controller do
    def create
      @errors = ActiveModel::Errors.new(AppConfig.new)
      setting_params.keys.each do |key|
        next if setting_params[key].nil?

        setting = AppConfig.new(var: key)
        setting.value = setting_params[key].strip
        unless setting.valid?
          @errors.merge!(setting.errors)
        end
      end

      if @errors.any?
        render :new
      end

      setting_params.keys.each do |key|
        AppConfig.send("#{key}=", setting_params[key].strip) unless setting_params[key].nil?
      end

      redirect_to admin_configurations_path, notice: "Setting was successfully updated."
    end

    def setting_params
      params.require(:app_config).permit(
        :captcha_enable, 
        :magic_link_enable,
        :login_with_google_oauth2_enable,
        :login_with_github_enable,
        :register_enable
      )
    end
  end

  form do |f|
    f.inputs do
      f.input :captcha_enable, as: :boolean
      f.input :magic_link_enable, as: :boolean
      f.input :login_with_google_oauth2_enable, as: :boolean
      f.input :login_with_github_enable, as: :boolean
      f.input :register_enable, as: :boolean
    end

    f.actions
  end
end