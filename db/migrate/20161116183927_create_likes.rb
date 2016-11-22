class CreateLikes < ActiveRecord::Migration[5.0]
  def change
    create_table :likes do |t|
      t.references :micropost, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps
    end
    add_index :likes, [:micropost_id, :user_id],
               unique: true, name: 'index_likes_for_uniqueness'
  end
end
