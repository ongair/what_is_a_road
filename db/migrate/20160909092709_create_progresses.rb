class CreateProgresses < ActiveRecord::Migration
  def change
    create_table :progresses do |t|
      t.references :report, index: true, foreign_key: true
      t.references :step, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
