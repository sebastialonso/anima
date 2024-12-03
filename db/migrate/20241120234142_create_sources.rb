class CreateSources < ActiveRecord::Migration[7.2]
  def change
    create_table :sources do |t|
      t.references :place, null: false, foreign_key: true
      t.string :name
      t.string :kind
      t.string :description
      t.string :link
      t.timestamps
    end
  end
end
