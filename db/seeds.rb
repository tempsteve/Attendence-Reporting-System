require 'csv'
require 'find'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create email: 'user@mail.com', password: 'userspasswd'
AdminUser.create email: 'user@mail.com', password: 'userspasswd'

# scan fixture paths
fixture_path = Rails.root.join('db','fixtures')
csv_file_paths = []
Find.find(fixture_path) do |path|
  csv_file_paths << path if /place\.csv$/.match path.to_s
end

# scan items
csv_items = []
csv_file_paths.each do |csv_file_path|
  CSV.foreach(File.path(csv_file_path)) do |col|
    if $. != 1 && !col[0].nil? && !col[0].empty?
      csv_items << col
    end
  end
end

# import data
csv_items.each do |csv_item|
  event = Event.find_or_create_by(name: csv_item[0])
  area = Area.find_or_create_by(name: csv_item[1])
  city = City.find_or_create_by(name: csv_item[2], area: area)
  school = School.find_or_create_by(name: csv_item[3], city: city)
  classroom = Classroom.find_or_create_by(name: csv_item[4], school: school)
  testtime = Testtime.find_or_create_by(name: csv_item[5])
  event_detail = EventDetail.find_or_create_by(event: event, classroom: classroom, testtime: testtime, expected: csv_item[6].to_i)
end

csv_file_paths = []
Find.find(fixture_path) do |path|
  csv_file_paths << path if /account\.csv$/.match path.to_s
end

csv_items = []
csv_file_paths.each do |csv_file_path|
  CSV.foreach(File.path(csv_file_path)) do |col|
    if $. != 1 && !col[0].nil? && !col[0].empty?
      csv_items << col
    end
  end
end

csv_items.each do |csv_item|
  User.create email: csv_item[0], password: csv_item[1]
  uid = User.where(:email => csv_item[0]).pluck(:id).to_param.to_i
  sid = School.where(:name => csv_item[2]).pluck(:id).to_param.to_i
  UserPermission.create user_id: uid, permissionable_id: sid, permissionable_type: "School"
end

UserPermission.create user_id: 1, permissionable_id: 1, permissionable_type: "Area"
UserPermission.create user_id: 1, permissionable_id: 2, permissionable_type: "Area"
UserPermission.create user_id: 1, permissionable_id: 3, permissionable_type: "Area"
UserPermission.create user_id: 1, permissionable_id: 4, permissionable_type: "Area"
UserPermission.create user_id: 2, permissionable_id: 1, permissionable_type: "Area"
UserPermission.create user_id: 2, permissionable_id: 2, permissionable_type: "Area"
UserPermission.create user_id: 2, permissionable_id: 3, permissionable_type: "Area"
UserPermission.create user_id: 2, permissionable_id: 4, permissionable_type: "Area"
