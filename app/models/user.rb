class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable
  devise :database_authenticatable, :rememberable, :trackable, :validatable
  has_many :user_permissions, :dependent => :destroy
  has_many :areas, through: :user_permissions, source: :permissionable, source_type: 'Area'
  has_many :cities, through: :user_permissions, source: :permissionable, source_type: 'City'
  has_many :schools, through: :user_permissions, source: :permissionable, source_type: 'School'
  has_many :classrooms, through: :user_permissions, source: :permissionable, source_type: 'Classroom'

  accepts_nested_attributes_for :user_permissions, allow_destroy: true

  def display_name
    "##{self.id} - #{self.email}"
  end

  def event_detail_ids
    event_detail_ids = []
    self.areas.each do |area|
      event_detail_ids |= area.event_detail_ids
    end
    self.cities.each do |city|
      event_detail_ids |= city.event_detail_ids
    end
    self.schools.each do |school|
      event_detail_ids |= school.event_detail_ids
    end
    self.classrooms.each do |classroom|
      event_detail_ids |= classroom.event_detail_ids
    end
    event_detail_ids.uniq
  end

  def is_admin?
    is_admin = true
    permissions = self.user_permissions.map(&:permissionable_type).uniq
    is_admin = false if permissions == ['Classroom'] || permissions == []
    return is_admin
  end

end
