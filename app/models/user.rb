class User < ApplicationRecord
  include Ransackable
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :two_factor_authenticatable,
         :omniauthable, omniauth_providers: [:google_oauth2, :github]

  # associations
  belongs_to :active_company, class_name: 'Company', optional: true
  has_many :user_companies, dependent: :restrict_with_exception
  has_many :companies, through: :user_companies
  has_many :auth_providers, dependent: :destroy

  # validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  def self.from_omniauth(oauth_data)
    data = oauth_data.info
    user = User.where(email: data['email']).first

    ActiveRecord::Base.transaction do
      user ||= User.create!(name: data['name'],
                            email: data['email'],
                            password: Devise.friendly_token[0, 20])

      user.update_or_register_provider(oauth_data)
    end

    user
  end

  def update_or_register_provider(oauth_data)
    data = oauth_data.info
    credential = oauth_data.credentials

    provider = auth_providers.find_or_initialize_by(name: oauth_data['provider'], uid: oauth_data['uid'])
    provider.access_token = credential['token']
    provider.refresh_token = credential['refresh_token'] if credential['refresh_token'].present?
    provider.expires_at = Time.at(credential['expires_at']).to_datetime if credential['expires_at'].present?
    provider.save!
  end
end
