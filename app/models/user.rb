class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # associations
  belongs_to :active_company, class_name: 'Company', optional: true
  has_many :user_companies, dependent: :restrict_with_exception
  has_many :companies, through: :user_companies
end
