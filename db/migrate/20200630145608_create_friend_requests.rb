class CreateFriendRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :friend_requests do |t|
      t.references :user, foreign_key: true
      t.integer :friend_id
      t.boolean :status, default: :false

      t.timestamps
    end
  end
end
