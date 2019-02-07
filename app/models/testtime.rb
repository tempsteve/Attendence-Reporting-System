class Testtime < ActiveRecord::Base
  has_many :event_details
  validates :name, uniqueness: true
end
