class ChangeUsersIsAdminColumn < ActiveRecord::Migration
  def up
  	change_column :users, :is_admin, :boolean, :default => false
  end

  def down
  end
end
