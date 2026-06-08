require "test_helper"
require "rake"

class ArticleTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @article = Article.new(title: "Valid Title", body: "Valid body text", user: @user)
    
    # Load rake tasks once for the cleanup test
    Rails.application.load_tasks if Rake::Task.tasks.empty?
  end

  test "should be valid with valid attributes" do
    assert @article.valid?
  end

  test "should require a title" do
    @article.title = nil
    assert_not @article.valid?
  end

  test "should require a body" do
    @article.body = nil
    assert_not @article.valid?
  end

  test "should archive when reports_count reaches 3" do
    @article.save!
    assert_not @article.archived?

    @article.update!(reports_count: 2)
    assert_not @article.archived?

    @article.update!(reports_count: 3)
    assert @article.archived?
  end

  test "rake task should delete articles reported 6 or more times" do
    # Create articles with different reports count
    a1 = Article.create!(title: "Reported 2", body: "body", user: @user, reports_count: 2)
    a2 = Article.create!(title: "Reported 5", body: "body", user: @user, reports_count: 5)
    a3 = Article.create!(title: "Reported 6", body: "body", user: @user, reports_count: 6)
    a4 = Article.create!(title: "Reported 7", body: "body", user: @user, reports_count: 7)

    # Re-enable the task to allow invoking it again in tests if needed
    Rake::Task["articles:cleanup_reported"].reenable
    
    assert_difference("Article.count", -2) do
      Rake::Task["articles:cleanup_reported"].invoke
    end

    assert Article.exists?(a1.id)
    assert Article.exists?(a2.id)
    assert_not Article.exists?(a3.id)
    assert_not Article.exists?(a4.id)
  end
end
