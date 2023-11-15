class AdminUser < ApplicationRecord
  include Ransackable
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :lockable,
         :recoverable, :rememberable, :validatable,
         :trackable
end
