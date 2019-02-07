class EventDetail < ActiveRecord::Base
  belongs_to :classroom
  belongs_to :testtime
  belongs_to :event

  validates :classroom, presence: true
  validates :testtime, presence: true
  validates :event, presence: true, uniqueness: { scope: [:classroom, :testtime] } 
  validates :expected, presence: true

  def absent
    return_val = nil
    begin
      return_val = (self.expected - self.actual)
    rescue
    end
  end
end
