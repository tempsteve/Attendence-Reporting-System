ActiveAdmin.register City do
  menu parent: '場地資訊', priority: 2, label: '城市'
  permit_params :name, :area_id
  index do
    selectable_column
    id_column
    column :area
    column :name
    column :created_at
    column :updated_at
    actions
  end
end
