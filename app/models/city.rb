class City < ActiveRecord::Base
  belongs_to :area
  has_many :schools
  has_many :classrooms, through: :schools
  has_many :event_details, through: :classrooms
  has_many :user_permissions, as: :permissionable

  validates :area, presence: true
  validates :name, uniqueness: true
end
