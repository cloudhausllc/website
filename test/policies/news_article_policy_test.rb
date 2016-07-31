require 'test_helper'

class NewsArticlePolicyTest < PolicyAssertions::Test
  def setup
    @regular_user = users(:regular_user)
    @user1 = users(:user1)
    @admin_user = users(:admin_user)
    @news_article = news_articles(:news_article)
    @available_actions = [:index, :new, :create, :edit, :update, :destroy]
  end

  def test_index
    #Everyone should be able to get index.
    assert_permit @admin_user, NewsArticle
    assert_permit @regular_user, NewsArticle
    assert_permit nil, NewsArticle
  end

  def test_edit_and_update
    #Only admins should be able ot get edit and update
    assert_permit @admin_user, @news_article
    refute_permit @regular_user, @news_article
    refute_permit nil, @news_article
  end

  def test_destroy
    #Only admins should be able to destroy
    assert_permit @admin_user, @news_article
    refute_permit @regular_user, @news_article
    refute_permit nil, @news_article
  end

  def test_create_and_new
    #Only admins should be able to get to new and create
    assert_permit @admin_user, NewsArticle
    refute_permit @regular_user, NewsArticle
    refute_permit nil, NewsArticle
  end

  def test_strong_parameters
    news_article_attributes = @news_article.attributes
    admin_params = [:id, :user_id, :subject, :body, :published]
    regular_user_params = []
    anonymous_params = []

    assert_strong_parameters(@admin_user, NewsArticle, news_article_attributes, admin_params)
    assert_strong_parameters(@regular_user, NewsArticle, news_article_attributes, regular_user_params)
    assert_strong_parameters(nil, NewsArticle, news_article_attributes, anonymous_params)
  end

end