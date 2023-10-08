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
    book = select_book
    theme = select_theme
    bookworm = select_bookworm

    recommendation = Recommendation.new(book: book, theme: theme, bookworm: bookworm)
    @recommendation_repository.create(recommendation)
  end

  def list_unread_recommendations
    recommendations = @recommendation_repository.unread_recommendations
    @recommendations_view.display(recommendations)
  end

  def list_my_recommendations(current_user)
    display_unread(current_user)
  end

  def mark_as_read(current_user)
    list_unread_recommendations
    index = @recommendations_view.ask_index
    my_recommendations = @recommendation_repository.my_unread_recommendations(current_user)
    recommendation = my_recommendations[index]
    @recommendation_repository.update_mark(recommendation)
  end

  private

  def select_book
    books = @book_repository.all
    @books_view.display_list(books)
    index = @recommendations_view.ask_index
    puts books[index]
    return books[index]
  end

  def select_theme
    themes = @theme_repository.all
    @themes_view.display_list(themes)
    index = @recommendations_view.ask_index
    puts themes[index]
    return themes[index]
  end

  def select_bookworm
    bookworms = @bookworm_repository.all_subscribers
    @sessions_view.display_subscribers(bookworms)
    index = @recommendations_view.ask_index
    bookworms[index]
    return bookworms[index]
  end

  def display_unread(user)
    recommendations = @recommendation_repository.my_unread_recommendations(user)
    return @recommendations_view.display(recommendations)
  end
end
