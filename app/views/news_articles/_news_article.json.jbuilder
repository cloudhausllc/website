json.extract! news_article, :id, :user_id, :subject, :body, :published, :created_at, :updated_at
json.url news_article_url(news_article, format: :json)