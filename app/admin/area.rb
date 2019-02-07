ActiveAdmin.register Area do
  menu parent: '場地資訊', priority: 1, label: '地區'
  permit_params :name
end
