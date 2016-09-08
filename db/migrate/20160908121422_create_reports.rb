class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.float :latitude
      t.float :longitude
      t.references :road, index: true, foreign_key: true
      t.text :comment
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
