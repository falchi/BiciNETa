class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.float :latitue
      t.float :longitude
      t.string :type
      t.string :address

      t.timestamps
    end
  end
end
