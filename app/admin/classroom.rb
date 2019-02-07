ActiveAdmin.register Classroom do
  menu parent: '場地資訊', priority: 4, label: '教室'
  permit_params :name, :school_id
  index do
    selectable_column
    id_column
    column :school
    column :name
    column :created_at
    column :updated_at
    actions
  end
end
