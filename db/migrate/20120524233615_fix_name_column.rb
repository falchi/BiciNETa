class FixNameColumn < ActiveRecord::Migration
  def up
    rename_column :points, :latitue, :latitude
  end

  def down
  end
end
