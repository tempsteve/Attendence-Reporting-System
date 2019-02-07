ActiveAdmin.register Announcement do
  menu priority: 8, label: '公告事項'
  permit_params :title, :content
end
