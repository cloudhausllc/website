require 'test_helper'

class NewsArticleTest < ActiveSupport::TestCase
  def setup
    @admin_user = users(:admin_user)
    @regular_user = users(:regular_user)

    @news_article = NewsArticle.new(
        subject: 'This is a subject!',
        body: 'This is a news article body!',
        user: @admin_user,
        published: true
    )

    @article_missing_user = NewsArticle.new(
        subject: 'This is a subject!',
        body: 'This is a news article body!',
        published: true
    )
  end

  test 'should be valid' do
    @news_article.valid?
  end

  test 'published can not be nil' do
    @news_article.published = nil
    refute @news_article.valid?
  end

  test 'subject can not be empty or nil' do
    [nil, '', ' ', "\n", "\t"].each do |test_value|
      @news_article.subject = test_value
      refute @news_article.valid?
    end
  end

  test 'body can not be empty or nil' do
    [nil, '', ' ', "\n", "\t"].each do |test_value|
      @news_article.body = test_value
      refute @news_article.valid?
    end
  end
end
