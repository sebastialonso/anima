class AddPostgisExtensionToDatabase < ActiveRecord::Migration[7.2]
  def change
    #enable_extension 'postgis'
    connection.execute('create extension if not exists "postgis"')
  end
end
