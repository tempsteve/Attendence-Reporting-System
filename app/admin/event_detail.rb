ActiveAdmin.register EventDetail do
  menu priority: 5, label: '應試資訊'
  permit_params :classroom_id, :testtime_id, :event_id, :expected, :actual, :retake, :violate, :note

  index do
    selectable_column
    column :event
    column :classroom
    column :testtime
    column :expected
    column :actual
    column :absent
    column :retake
    column :violate
    column :note
    actions
  end

  filter :event
  filter :classroom
  filter :testtime
  filter :expected
  filter :actual
  filter :absent
  filter :retake
  filter :violate
  filter :note

end
