class UserPermission < ActiveRecord::Base
  before_validation :assign_permissionable
  belongs_to :permissionable, polymorphic: true
  validates :permissionable, presence: true
  belongs_to :user

  attr_accessor :permissionable_area, :permissionable_city, :permissionable_school, :permissionable_classroom

  def permissionable_area
    self.permissionable.id if self.permissionable.is_a? Area
  end

  def permissionable_city
    self.permissionable.id if self.permissionable.is_a? City
  end

  def permissionable_school
    self.permissionable.id if self.permissionable.is_a? School
  end

  def permissionable_classroom
    self.permissionable.id if self.permissionable.is_a? Classroom
  end

  protected
    def assign_permissionable
      if !@permissionable_area.blank? && !@permissionable_city.blank? && !@permissionable_school.blank? && !@permissionable_classroom.blank?
        errors.add(:permissionable, "can't have an Area, a City, a School or a Classroom") 
      end

      unless @permissionable_area.blank?
        self.permissionable = Area.find(@permissionable_area)
      end

      unless @permissionable_city.blank?
        self.permissionable = City.find(@permissionable_city)
      end

      unless @permissionable_school.blank?
        self.permissionable = School.find(@permissionable_school)
      end

      unless @permissionable_classroom.blank?
        self.permissionable = Classroom.find(@permissionable_classroom)
      end
    end
end
