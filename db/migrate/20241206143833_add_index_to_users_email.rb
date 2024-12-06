class AddIndexToUsersEmail < ActiveRecord::Migration[7.2]
  def change
    add_index :users, 'LOWER(email)', unique: true, name: 'index_users_on_lowercase_email' 
  end
end
