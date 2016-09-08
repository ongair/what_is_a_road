class AddCompleteToReport < ActiveRecord::Migration
  def change
    add_column :reports, :complete, :boolean, default: false
  end
end
