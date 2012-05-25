class ChangePointTypeColumn < ActiveRecord::Migration
  def up
    rename_column :points, :type, :place
  end

  def down
  end
end
