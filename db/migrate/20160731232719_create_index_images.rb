class CreateIndexImages < ActiveRecord::Migration
  def change
    create_table :index_images do |t|
      t.boolean :active, null: false, default: false
      t.integer :user_id, null: false
      t.attachment :image

      t.timestamps null: false
    end
  end
end
