# RailsSettings Model
class AppConfig < RailsSettings::Base
  cache_prefix { "app_config" }

  # Define your fields
  # field :host, type: :string, default: "http://localhost:3000"
  # field :default_locale, default: "en", type: :string
  # field :confirmable_enable, default: "0", type: :boolean
  # field :admin_emails, default: "admin@rubyonrails.org", type: :array
  # field :omniauth_google_client_id, default: (ENV["OMNIAUTH_GOOGLE_CLIENT_ID"] || ""), type: :string, readonly: true
  # field :omniauth_google_client_secret, default: (ENV["OMNIAUTH_GOOGLE_CLIENT_SECRET"] || ""), type: :string, readonly: true

  scope :authentication do
    field :captcha_enable, default: false, type: :boolean
    field :magic_link_enable, default: false, type: :boolean

    field :login_with_google_oauth2_enable, default: false, type: :boolean
    field :login_with_github_enable, default: false, type: :boolean
  end

  scope :authorization do
    field :register_enable, default: false, type: :boolean
  end
end
