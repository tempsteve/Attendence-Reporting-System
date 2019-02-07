ActiveAdmin.register User do
  menu priority: 6, label: '前台使用者'

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "使用者資訊" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.has_many :user_permissions, :allow_destroy => true, :heading => '使用者權限(一次表單請選擇一個權限)' do |user_permission|
      user_permission.input :permissionable_area, label: '地區權限', collection: Area.all
      user_permission.input :permissionable_school, label: '學校權限', collection: School.all
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end

    def update
      @user = User.find(params[:id])
      if params[:user][:password].blank?
       @user.update_without_password(permitted_params[:user])
      else
       @user.update_attributes(permitted_params[:user])
      end
      if @user.errors.blank?
       redirect_to admin_users_path, :notice => "User updated successfully."
      else
       render :edit
      end
     end
  end
end
