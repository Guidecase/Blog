require_relative 'test_helper'

class ArticleTest < MiniTest::Unit::TestCase
  def setup
    @article = Blog::Article.new
  end

  def test_language_params
    params = Blog::Article.send :language_params, 'en'

    assert_equal 3, params.size
    assert params.include?({:language => 'en'})
    assert params.include?({:language => ''})
    assert params.include?({:language => nil})
  end

  def test_global_finder
    global = Blog::Article.create! :title => 'test'
    owned = Blog::Article.create! :title => 'test', :owner_id => '123abc'

    articles = Blog::Article.global
    assert_equal [global], articles.entries

    p2 = Blog::Article.create! :title => 'p2', :published_at => Time.now - 1.hour
    articles = Blog::Article.global nil, 1, 1
    assert_equal [global], articles.entries

    articles = Blog::Article.global nil, 2, 1
    assert_equal [p2], articles.entries
  end

  def test_owned_finder
    global = Blog::Article.create! :title => 'test'
    owned = Blog::Article.create! :title => 'test', :owner_id => '123abc'

    articles = Blog::Article.owned nil, owned.owner_id
    assert_equal [owned], articles.entries

    p2 = Blog::Article.create! :title => 'p2', :owner_id => owned.owner_id, :published_at => Time.now - 1.hour
    articles = Blog::Article.owned nil, owned.owner_id, 1, 1
    assert_equal [owned], articles.entries

    articles = Blog::Article.owned nil, owned.owner_id, 2, 1
    assert_equal [p2], articles.entries
  end

  def test_owned_finder_with_language_param
    none = Blog::Article.create! :title => 'no language'
    en = Blog::Article.create! :title => 'en language', :language => 'en' 
    nl = Blog::Article.create! :title => 'nl language', :language => 'nl'

    articles = Blog::Article.owned 'en', nil
    assert_equal [none,en].sort, articles.entries.sort
  end

  def test_owned_finder_with_pagination
    11.times {|i| Blog::Article.create! :title => "Article #{i}" }

    assert_equal 10, Blog::Article.owned(nil, nil).to_a.size
    assert_equal 10, Blog::Article.owned(nil, nil, 0).to_a.size
    assert_equal 10, Blog::Article.owned(nil, nil, '1').to_a.size
    assert_equal 1, Blog::Article.owned(nil, nil, 2).to_a.size 
  end

  def test_article_to_param_is_slug
    assert_equal @article._id.to_s, @article.to_param

    @article.slug = 'test'
    assert_equal @article.slug, @article.to_param
  end

  def test_is_offsite_artlce_link
    assert_equal false, @article.offsite?

    @article.body = "visit http://www.example.com"
    assert_equal false, @article.offsite?

    @article.body = "http://www.example.com"
    assert_equal true, @article.offsite?

    @article.body = "https://www.example.com"
    assert_equal true, @article.offsite?
  end
end