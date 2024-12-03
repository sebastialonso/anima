class CreatePlaces < ActiveRecord::Migration[7.2]
  def change
    create_table :places do |t|
      t.string :name
      t.string :code
      t.st_point :lonlat, geographic: true
      t.string :published_status, default: "IN_REVIEW"
      t.string :status, default: "ACTIVE"
      t.timestamps
    end
  end
end
