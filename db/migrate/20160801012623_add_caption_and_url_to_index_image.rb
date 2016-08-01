class AddCaptionAndUrlToIndexImage < ActiveRecord::Migration
  def change
    add_column :index_images, :caption, :text
    add_column :index_images, :url, :text
  end
end
