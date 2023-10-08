require_relative "../views/book_view"
require_relative "../views/theme_view"
require_relative "../views/session_view"
require_relative "../views/recommendation_view"

class RecommendationsController
  def initialize(book_repository, theme_repository, bookworm_repository, recommendation_repository)
    @book_repository = book_repository
    @theme_repository = theme_repository
    @bookworm_repository = bookworm_repository
    @recommendation_repository = recommendation_repository

    @books_view = BookView.new
    @themes_view = ThemeView.new
    @sessions_view = SessionView.new
    @recommendations_view = RecommendationView.new
  end

  def add
    books = @book_repository.all
    @books_view.display_list(books)
    book_id = @recommendations_view.ask_index
    book = books[book_id]

    themes = @theme_repository.all
    @themes_view.display_list(themes)
    theme_id = @recommendations_view.ask_index
    theme = themes[theme_id]

    bookworms = @bookworm_repository.all_subscribers
    @sessions_view.display_subscribers(bookworms)
    bookworm_id = @recommendations_view.ask_index
    bookworm = bookworms[bookworm_id]

    recommendation = Recommendation.new(book: book, theme: theme, bookworm: bookworm)
    @recommendation_repository.create(recommendation)
  end

  def list_unread_recommendations
    recommendations = @recommendation_repository.unread_recommendations
    @recommendations_view.display(recommendations)
  end

  def list_my_recommendations(subscriber)
    display_unread(subscriber)
  end

  def mark_as_read(subscriber)
    recommendations = display_unread(subscriber)
    index = @recommendations_view.ask_index
    recommendation = recommendations[index]
    @recommendation_repository.update_mark(recommendation)
  end

  private

  def display_unread(subscriber)
    recommendations = @recommendation_repository.my_unread_recommendations(subscriber)
    @recommendations_view.display(recommendations)
    return recommendations
  end
end
