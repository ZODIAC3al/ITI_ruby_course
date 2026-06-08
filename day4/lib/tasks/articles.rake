namespace :articles do
  desc "Remove articles that have been reported 6 or more times"
  task cleanup_reported: :environment do
    reported_articles = Article.where("reports_count >= 6")
    count = reported_articles.count
    reported_articles.destroy_all
    puts "Successfully removed #{count} articles reported 6 or more times."
  end
end
