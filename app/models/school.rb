class School < ActiveRecord::Base
  belongs_to :city
  has_many :classrooms
  has_many :event_details, through: :classrooms
  has_many :user_permissions, as: :permissionable

  validates :city, presence: true
  validates :name, uniqueness: true

  def generate_classroom(count = 1)
    count.times do |index|
      self.classrooms.create name: "第#{index+1}試場"
    end
  end
end
