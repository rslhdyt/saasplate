class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :two_factor_authenticatable

  # associations
  belongs_to :active_company, class_name: 'Company', optional: true
  has_many :user_companies, dependent: :restrict_with_exception
  has_many :companies, through: :user_companies

  # validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
