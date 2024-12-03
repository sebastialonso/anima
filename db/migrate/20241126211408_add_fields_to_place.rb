class AddFieldsToPlace < ActiveRecord::Migration[7.2]
  def change
    add_column :places, :subject, :string
    add_column :places, :date_info, :string
  end
end
