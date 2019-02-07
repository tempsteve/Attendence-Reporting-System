class Area < ActiveRecord::Base
  has_many :cities
  has_many :schools, through: :cities
  has_many :classrooms, through: :schools
  has_many :event_details, through: :classrooms
  has_many :user_permissions, as: :permissionable
  validates :name, uniqueness: true
end
