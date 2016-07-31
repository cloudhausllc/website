class CreateNewsArticles < ActiveRecord::Migration
  def change
    create_table :news_articles do |t|
      t.integer :user_id, null: false
      t.text :subject
      t.text :body
      t.boolean :published, default: false, null: false

      t.timestamps null: false
    end
  end
end