ActiveAdmin.register School do
  menu parent: '場地資訊', priority: 3, label: '學校'

  permit_params :name, :city_id

  index do
    selectable_column
    id_column
    column :city
    column :name
    column :created_at
    column :updated_at
    actions
  end

end
