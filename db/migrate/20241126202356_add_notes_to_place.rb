class AddNotesToPlace < ActiveRecord::Migration[7.2]
  def change
    add_column :places, :notes, :text
  end
end
