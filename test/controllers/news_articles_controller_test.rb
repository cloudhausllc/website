require 'test_helper'

class NewsArticlesControllerTest < ActionController::TestCase
  setup do

    @news_article = news_articles(:news_article)
    @news_article_subject = @news_article.subject
    @news_article_body = @news_article.body
    @new_subject = 'This is a new subject!'
    @new_body = 'This is a new article body!'

    @published_article = news_articles(:published_article)
    @unpublished_article = news_articles(:unpublished_article)

    # @published_subject = @published_article.subject
    # @published_body = @published_article.body
    #
    # @unpublished_subject = @unpublished_article.subject
    # @unpublished_body = @unpublished_article.body

    @admin_user = users(:admin_user)
    @regular_user = users(:regular_user)

  end

  teardown do
    log_out
  end

  test 'all users should be able to get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:news_articles)

    log_in(@admin_user)
    get :index
    assert_response :success
    assert_not_nil assigns(:news_articles)

    log_in(@regular_user)
    get :index
    assert_response :success
    assert_not_nil assigns(:news_articles)
  end

  test 'admin should get new' do
    log_in(@admin_user)
    get :new
    assert_response :success
  end

  test 'regular user should not get new' do
    log_in(@regular_user)
    get :new
    assert_redirected_to root_path
  end

  test 'anon user should not get new' do
    get :new
    assert_redirected_to root_path
  end

  test 'admin should be able to create news_article' do
    log_in(@admin_user)
    assert_difference('NewsArticle.count') do
      post :create, news_article: {body: @news_article.body, published: @news_article.published, subject: @news_article.subject, user_id: @news_article.user_id}
    end

    assert_redirected_to news_article_path(assigns(:news_article))
  end

  test 'regular user should not be able to create news_article' do
    log_in(@regular_user)
    assert_difference('NewsArticle.count', 0) do
      post :create, news_article: {body: @news_article.body, published: @news_article.published, subject: @news_article.subject, user_id: @news_article.user_id}
    end

    assert_redirected_to root_path
  end

  test 'anon user should not be able to create news_article' do
    assert_difference('NewsArticle.count', 0) do
      post :create, news_article: {body: @news_article.body, published: @news_article.published, subject: @news_article.subject, user_id: @news_article.user_id}
    end

    assert_redirected_to root_path
  end

  test 'all users should show published article' do
    get :show, id: @published_article
    assert_response :success

    log_in(@admin_user)
    get :show, id: @published_article
    assert_response :success

    log_in(@regular_user)
    get :show, id: @published_article
    assert_response :success
  end

  test 'admin should show unpublished article' do
    log_in(@admin_user)
    get :show, id: @unpublished_article
    assert_response :success
  end

  test 'non admin should not show unpublished article' do
    assert_raises ActiveRecord::RecordNotFound do
      get :show, id: @unpublished_article
    end

    log_in(@regular_user)
    assert_raises ActiveRecord::RecordNotFound do
      get :show, id: @unpublished_article
    end
  end

  test 'admin should get edit' do
    log_in(@admin_user)
    get :edit, id: @published_article
    assert_response :success
  end

  test 'regular user should not get edit' do
    log_in(@regular_user)
    get :edit, id: @news_article
    assert_redirected_to root_path
  end

  test 'anon should not get edit' do
    get :edit, id: @news_article
    assert_redirected_to root_path
  end

  test 'admin should update news_article' do
    log_in(@admin_user)
    patch :update, id: @news_article, news_article: {body: @new_body, published: @news_article.published, subject: @new_subject, user_id: @news_article.user_id}

    assert_equal @new_subject, @news_article.reload.subject
    assert_equal @new_body, @news_article.reload.body

    assert_redirected_to news_article_path(assigns(:news_article))
  end

  test 'regular user should not update news_article' do
    log_in(@regular_user)
    patch :update, id: @news_article, news_article: {body: @new_body, published: @news_article.published, subject: @new_subject, user_id: @news_article.user_id}

    refute_same @news_article.reload.subject, @new_subject
    refute_same @news_article.reload.body, @new_body

    assert_redirected_to root_path
  end

  test 'anon user should not update news_article' do
    patch :update, id: @news_article, news_article: {body: @new_body, published: @news_article.published, subject: @new_subject, user_id: @news_article.user_id}

    refute_same @news_article.reload.subject, @new_subject
    refute_same @news_article.reload.body, @new_body

    assert_redirected_to root_path
  end

  test 'admin should destroy news_article' do
    log_in(@admin_user)
    assert_difference('NewsArticle.count', -1) do
      delete :destroy, id: @news_article
    end

    assert_redirected_to news_articles_path
  end

  test 'regular user should not destroy news_article' do
    log_in(@regular_user)
    assert_difference('NewsArticle.count', 0) do
      delete :destroy, id: @news_article
    end

    assert_redirected_to root_path
  end

  test 'anon user should not destroy news_article' do
    assert_difference('NewsArticle.count', 0) do
      delete :destroy, id: @news_article
    end

    assert_redirected_to root_path
  end
end
