class AddCodeIndexToPlace < ActiveRecord::Migration[7.2]
  def change
    add_index :places, :code, unique: true
  end
end
