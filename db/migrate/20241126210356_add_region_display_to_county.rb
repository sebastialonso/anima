class AddRegionDisplayToCounty < ActiveRecord::Migration[7.2]
  def change
    add_column :counties, :region_display, :string
  end
end
