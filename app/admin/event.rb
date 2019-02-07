ActiveAdmin.register Event do
  menu priority: 3, label: '考試活動'

  permit_params :name, :event_date

  index do
    selectable_column
    id_column
    column :name
    column :event_date
    column :created_at
    column :updated_at
    actions defaults: true do |event|
      link_to("區域報表", by_area_admin_event_path(event), class: :member_link) + link_to("城市報表", by_city_admin_event_path(event), class: :member_link) + link_to("學校報表", by_school_admin_event_path(event), class: :member_link)
    end
  end

  member_action :by_area, :method => :get do
    @areas = Event.find(params[:id]).uniq_areas
  end

  member_action :by_city, :method => :get do
    @cities = Event.find(params[:id]).uniq_cities
  end

  member_action :by_school, :method => :get do
    @schools = Event.find(params[:id]).uniq_schools
  end

end
