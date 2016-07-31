class IndexController < ApplicationController
  def index
    @news_articles = NewsArticle.includes(:user).where(published: true)
  end
end
