class ArticlesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]
  before_action :set_article, only: %i[ show edit update destroy report ]
  before_action :require_author, only: %i[ edit update destroy ]

  def index
    # Guests only see non-archived public articles
    @articles = Article.where(public: true, archived: false).order(created_at: :desc)
    
    # Authenticated users also see their own articles
    if authenticated?
      @my_articles = Current.user.articles.order(created_at: :desc)
    end
  end

  def show
    # Enforce read permissions:
    # If the article is public and not archived, anyone can see it.
    # Otherwise (private or archived), only the author can see it.
    unless (@article.public? && !@article.archived?) || (authenticated? && Current.user == @article.user)
      redirect_to root_path, alert: "You are not authorized to access this article."
    end
  end

  def new
    @article = Current.user.articles.build
  end

  def create
    @article = Current.user.articles.build(article_params)
    if @article.save
      redirect_to @article, notice: "Article was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: "Article was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, status: :see_other, notice: "Article was successfully deleted."
  end

  def report
    if Current.user == @article.user
      redirect_to @article, alert: "You cannot report your own article."
    else
      @article.reports_count += 1
      if @article.save
        if @article.archived?
          redirect_to root_path, notice: "Article was reported and has been archived due to excessive reports."
        else
          redirect_to @article, notice: "Thank you for reporting this article."
        end
      else
        redirect_to @article, alert: "Failed to report article."
      end
    end
  end

  private

  def set_article
    @article = Article.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Article not found."
  end

  def require_author
    unless Current.user == @article.user
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end

  def article_params
    params.require(:article).permit(:title, :body, :public, :image)
  end
end
