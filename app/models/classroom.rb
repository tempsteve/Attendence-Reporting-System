class Classroom < ActiveRecord::Base
  belongs_to :school
  has_many :event_details
  has_many :user_permissions, as: :permissionable

  validates :school, presence: true
  validates :name, uniqueness: { scope: :school }

  def display_name
    school = self.school
    "#{school.name}-#{self.name}"
  end
end
