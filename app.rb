require_relative 'router'
require_relative 'app/repositories/book_repository'
require_relative 'app/controllers/books_controller'
require_relative 'app/repositories/bookworm_repository'
require_relative 'app/controllers/sessions_controller'
require_relative 'app/repositories/recommendation_repository'
require_relative 'app/controllers/recommendations_controller'
require_relative 'app/repositories/theme_repository'
require_relative 'app/controllers/themes_controller'

book_csv_file = File.join(__dir__, 'data/books.csv')

book_repo = BookRepository.new(book_csv_file)
book_controller = BooksController.new(book_repo)

theme_csv_file = File.join(__dir__, 'data/themes.csv')

theme_repo = ThemeRepository.new(theme_csv_file)
themes_controller = ThemesController.new(theme_repo)

bookworm_csv_file = File.join(__dir__, 'data/bookworms.csv')

bookworm_repo = BookwormRepository.new(bookworm_csv_file)
sessions_controller = SessionsController.new(bookworm_repo)

recommendation_csv_file = File.join(__dir__, 'data/recommendations.csv')

recommendation_repo = RecommendationRepository.new(recommendation_csv_file, book_repo, theme_repo, bookworm_repo)
recommendations_controller = RecommendationsController.new(book_repo, theme_repo, bookworm_repo, recommendation_repo)

router = Router.new(book_controller, themes_controller, sessions_controller, recommendations_controller)

router.run
