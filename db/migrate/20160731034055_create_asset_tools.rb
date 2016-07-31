class CreateAssetTools < ActiveRecord::Migration
  def change
    create_table :asset_tools do |t|
      t.boolean :active, null: false, default: false
      t.boolean :on_premises, null: false, default: false
      t.integer :value
      t.text :name
      t.integer :user_id, null: false
      t.integer :quantity, null: false, default: 1
      t.text :url
      t.integer :sqft
      t.text :model_number
      t.text :notes

      t.timestamps null: false
    end
  end
end
