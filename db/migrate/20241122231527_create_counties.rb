class CreateCounties < ActiveRecord::Migration[7.2]
  def change
    create_table :counties do |t|
      t.string :name
      t.string :code
      t.string :raw_comune
      t.string :raw_province
      #t.polygon :polygon, geographic: true
      t.st_polygon :polygon, geographic: true

      t.timestamps
    end
  end
end
