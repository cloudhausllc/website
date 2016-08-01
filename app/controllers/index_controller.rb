class IndexController < ApplicationController
  def index
    @news_articles = NewsArticle.includes(:user).where(published: true)
    @index_images = IndexImage.where(active: true)
  end
end
