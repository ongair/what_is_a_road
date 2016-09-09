class AddPromptTextToStep < ActiveRecord::Migration
  def change
    add_column :steps, :prompt_text, :string
  end
end
