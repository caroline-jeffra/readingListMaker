require 'fileutils'
require_relative 'support/csv_helper'

begin
  require_relative '../app/models/book'
  require_relative '../app/models/theme'
  require_relative '../app/models/bookworm'
  require_relative '../app/models/recommendation'
  require_relative '../app/repositories/book_repository'
  require_relative '../app/repositories/theme_repository'
  require_relative '../app/repositories/bookworm_repository'
  require_relative '../app/repositories/recommendation_repository'
  require_relative '../app/controllers/recommendations_controller'
rescue => e
  raise e
end

describe 'Recommendation', :_recommendation do
  describe '#initialize' do
    it 'Takes a hash of attributes as a parameter' do
      properties = { id: 1, read: false }
      recommendation = Recommendation.new(properties)
      expect(recommendation).to be_a(Recommendation)
    end

    it 'Receives the :book attribute, which is an instance of Book' do
      properties = { book: Book.new({}) }
      recommendation = Recommendation.new(properties)
      expect(recommendation.instance_variable_get(:@book)).to be_a(Book)
    end

    it 'Receives the :theme attribute, which is an instance of Theme' do
      properties = { theme: Theme.new({}) }
      recommendation = Recommendation.new(properties)
      expect(recommendation.instance_variable_get(:@theme)).to be_a(Theme)
    end

    it 'Receives the :bookworm attribute, which is an instance of Bookworm' do
      properties = { bookworm: Bookworm.new({}) }
      recommendation = Recommendation.new(properties)
      expect(recommendation.instance_variable_get(:@bookworm)).to be_a(Bookworm)
    end
  end

  describe '#id' do
    it 'Should return the recommendation id' do
      recommendation = Recommendation.new(id: 42)
      expect(recommendation.id).to eq(42)
    end
  end

  describe '#id=' do
    it 'Should set the recommendation id' do
      recommendation = Recommendation.new(id: 42)
      recommendation.id = 43
      expect(recommendation.id).to eq(43)
    end
  end

  describe '#read?' do
    it 'Should return true if the recommendation has been read' do
      recommendation = Recommendation.new(read: true)
      expect(recommendation.read?).to be true
    end

    it 'Should return false if the recommendation has not yet been read' do
      recommendation = Recommendation.new({})
      expect(recommendation.read?).to be false
    end
  end

  describe '#book' do
    it 'Should return the book associated with the recommendation' do
      recommendation = Recommendation.new(book: Book.new({}))
      expect(recommendation.book).to be_a(Book)
    end
  end

  describe '#bookworm' do
    it 'Should return the bookworm associated with the recommendation' do
      recommendation = Recommendation.new(bookworm: Bookworm.new({}))
      expect(recommendation.bookworm).to be_a(Bookworm)
    end
  end

  describe '#theme' do
    it 'Should return the theme associated with the recommendation' do
      recommendation = Recommendation.new(theme: Theme.new({}))
      expect(recommendation.theme).to be_a(Theme)
    end
  end

  describe '#read!' do
    it 'Should mark an recommendation as read' do
      recommendation = Recommendation.new(id: 12)
      expect(recommendation.read?).to be false
      recommendation.read!
      expect(recommendation.read?).to be true
    end
  end
end

describe 'RecommendationRepository', :_recommendation do
  let(:book) do
    [
      %w[id title author genre description isbn],
      [1, 'Title 1', 'Author 1', 'Genre 1', 'description text for title 1', 9_780_575_094_185],
      [2, 'Title 2', 'Author 2', 'Genre 2', 'description text for title 2', 9_780_575_094_186],
      [3, 'Title 3', 'Author 3', 'Genre 3', 'description text for title 3', 9_780_575_094_187]
    ]
  end
  let(:book_csv_path) { 'spec/support/book.csv' }
  let(:book_repository) { BookRepository.new(book_csv_path) }

  let(:themes) do
    [
      %w[id name description],
      [1, 'theme 1', 'A nice little theme with cool books in it'],
      [2, 'theme 2', 'A nice little theme with cool books in it'],
      [3, 'theme 3', 'A nice little theme with cool books in it']
    ]
  end
  let(:themes_csv_path) { 'spec/support/themes.csv' }
  let(:theme_repository) { ThemeRepository.new(themes_csv_path) }

  let(:bookworms) do
    [
      %w[id username password role],
      [1, 'paulAtreides', 'secret', 'manager'],
      [2, 'ladyJessica', 'secret', 'subscriber'],
      [3, 'gurney', 'secret', 'subscriber']
    ]
  end
  let(:bookworms_csv_path) { 'spec/support/bookworms.csv' }
  let(:bookworm_repository) { BookwormRepository.new(bookworms_csv_path) }

  let(:recommendations) do
    [
      %w[id read book_id theme_id bookworm_id],
      [1, true, 1, 1, 2],
      [2, false, 1, 2, 2],
      [3, false, 2, 3, 2]
    ]
  end
  let(:recommendations_csv_path) { 'spec/support/recommendations.csv' }
  let(:recommendation_repository) { RecommendationRepository.new(recommendations_csv_path) }

  before(:each) do
    CsvHelper.write_csv(book_csv_path, book)
    CsvHelper.write_csv(themes_csv_path, themes)
    CsvHelper.write_csv(bookworms_csv_path, bookworms)
    CsvHelper.write_csv(recommendations_csv_path, recommendations)
  end

  def elements(repo)
    repo.instance_variable_get(:@recommendations) ||
      repo.instance_variable_get(:@elements)
  end

  describe '#initialize' do
    it 'Should take 4 arguments: the CSV file path to store recommendations, and 3 repository instances (book, theme and bookworm)' do
      expect(RecommendationRepository.instance_method(:initialize).arity).to eq(4)
    end

    it 'Should not crash if the CSV path does not exist yet' do
      expect { RecommendationRepository.new('fake_file.csv', book_repository, theme_repository, bookworm_repository) }.not_to raise_error
    end

    it 'Store the 3 auxiliary repositories in instance variables' do
      repo = RecommendationRepository.new(recommendations_csv_path, book_repository, theme_repository, bookworm_repository)
      expect(repo.instance_variable_get(:@book_repository)).to be_a(BookRepository)
      expect(repo.instance_variable_get(:@theme_repository)).to be_a(ThemeRepository)
      expect(repo.instance_variable_get(:@bookworm_repository)).to be_a(BookwormRepository)
    end

    it 'Store recommendations in memory in an instance variable `@recommendations` or `@elements`' do
      repo = RecommendationRepository.new(recommendations_csv_path, book_repository, theme_repository, bookworm_repository)
      expect(elements(repo)).to be_a(Array)
    end

    it 'Should load existing recommendations from the CSV' do
      repo = RecommendationRepository.new(recommendations_csv_path, book_repository, theme_repository, bookworm_repository)
      loaded_recommendations = elements(repo) || []
      expect(loaded_recommendations.length).to eq(3)
    end

    it 'Should fill the `@recommendations` or `@elements` array of recommendations with instance of `Recommendation`, setting the correct types on each property' do
      repo = RecommendationRepository.new(recommendations_csv_path, book_repository, theme_repository, bookworm_repository)
      loaded_recommendations = elements(repo) || []
      fail if loaded_recommendations.empty?

      loaded_recommendations.each do |recommendation|
        expect(recommendation).to be_a(Recommendation)
        expect(recommendation.book).to be_a(Book)
        expect(recommendation.bookworm).to be_a(Bookworm)
        expect(recommendation.theme).to be_a(Theme)
      end
      expect(loaded_recommendations[0].instance_variable_get(:@read)).to be true
      expect(loaded_recommendations[1].instance_variable_get(:@read)).to be false
      expect(loaded_recommendations[2].instance_variable_get(:@read)).to be false
    end
  end

  describe '#create' do
    it 'Should add an recommendation to the in-memory list' do
      repo = RecommendationRepository.new(recommendations_csv_path, book_repository, theme_repository, bookworm_repository)
      new_recommendation = Recommendation.new({
                                                book: book_repository.find(1),
                                                theme: theme_repository.find(1),
                                                bookworm: bookworm_repository.find(1)
                                              })
      repo.create(new_recommendation)
      expect(elements(repo).length).to eq(4)
    end

    it 'Should set the new recommendation id' do
      repo = RecommendationRepository.new(recommendations_csv_path, book_repository, theme_repository, bookworm_repository)
      new_recommendation = Recommendation.new({
        book: book_repository.find(1),
        theme: theme_repository.find(1),
        bookworm: bookworm_repository.find(1)
      })
      repo.create(new_recommendation)
      expect(new_recommendation.id).to eq(4)
    end

    it 'Should start auto-incrementing at 1 if it is the first recommendation added' do
      recommendations_csv_path = 'fake_empty_recommendations.csv'
      FileUtils.remove_file(recommendations_csv_path, force: true)

      repo = RecommendationRepository.new(recommendations_csv_path, book_repository, theme_repository, bookworm_repository)
      new_recommendation = Recommendation.new({
                                                book: book_repository.find(1),
                                                theme: theme_repository.find(1),
                                                bookworm: bookworm_repository.find(1)
                                              })
      repo.create(new_recommendation)
      expect(new_recommendation.id).to eq(1)

      FileUtils.remove_file(recommendations_csv_path, force: true)
    end

    it 'Should save each new recommendation in the CSV' do
      recommendations_csv_path = 'spec/support/empty_recommendations.csv'
      FileUtils.remove_file(recommendations_csv_path, force: true)

      repo = RecommendationRepository.new(recommendations_csv_path, book_repository, theme_repository, bookworm_repository)
      new_recommendation = Recommendation.new({
                                                book: book_repository.find(1),
                                                theme: theme_repository.find(1),
                                                bookworm: bookworm_repository.find(1)
                                              })
      repo.create(new_recommendation)

      repo = RecommendationRepository.new(recommendations_csv_path, book_repository, theme_repository, bookworm_repository)
      expect(repo.unread_recommendations.length).to eq(1)
      expect(repo.unread_recommendations[0].id).to eq(1)
      expect(repo.unread_recommendations[0].book).to be_a(Book)
      expect(repo.unread_recommendations[0].book.id).to eq(1)
      expect(repo.unread_recommendations[0].bookworm).to be_a(Bookworm)
      expect(repo.unread_recommendations[0].bookworm.id).to eq(1)
      expect(repo.unread_recommendations[0].theme).to be_a(Theme)
      expect(repo.unread_recommendations[0].theme.id).to eq(1)

      FileUtils.remove_file(recommendations_csv_path, force: true)
    end
  end

  describe '#unread_recommendations' do
    it 'Should return all the unread recommendations' do
      repo = RecommendationRepository.new(recommendations_csv_path, book_repository, theme_repository, bookworm_repository)
      expect(repo.unread_recommendations).to be_a(Array)
      expect(repo.unread_recommendations.length).to eq(2)
      expect(repo.unread_recommendations[0]).to be_a(Recommendation)
      expect(repo.unread_recommendations[1]).to be_a(Recommendation)
      expect(repo.unread_recommendations[0].read?).to be false
      expect(repo.unread_recommendations[1].read?).to be false
    end

    it 'RecommendationRepository should not expose the @recommendations through a reader/method' do
      repo = RecommendationRepository.new(recommendations_csv_path, book_repository, theme_repository, bookworm_repository)
      expect(repo).not_to respond_to(:recommendations)
    end
  end
end

describe 'RecommendationsController', :_recommendation do
  let(:books) do
    [
      ['id', 'title', 'author', 'genre', 'description', 'isbn'],
      [ 1, 'Title 1', 'Author 1', 'Genre 1', 'description text for title 1', 9_780_575_094_185],
      [ 2, 'Title 2', 'Author 2', 'Genre 2', 'description text for title 2', 9_780_575_094_186],
      [ 3, 'Title 3', 'Author 3', 'Genre 3', 'description text for title 3', 9_780_575_094_187],
      [ 4, 'Title 4', 'Author 2', 'Genre 2', 'description text for title 4', 9_780_575_094_286],
      [ 5, 'Title 5', 'Author 3', 'Genre 3', 'description text for title 5', 9_780_575_094_387]
    ]
  end
  let(:books_csv_path) { 'spec/support/books.csv' }
  let(:book_repository) { BookRepository.new(books_csv_path) }

  let(:themes) do
    [
      [ 'id', 'name', 'description' ],
      [ 1, 'theme 1', 'A nice little theme with cool books in it' ],
      [ 2, 'theme 2', 'A nice little theme with cool books in it' ],
      [ 3, 'theme 3', 'A nice little theme with cool books in it' ]
    ]
  end
  let(:themes_csv_path) { 'spec/support/themes.csv' }
  let(:theme_repository) { ThemeRepository.new(themes_csv_path) }

  let(:bookworms) do
    [
      [ 'id', 'username', 'password', 'role' ],
      [ 1, 'paulAtreides', 'secret', 'manager' ],
      [ 2, 'ladyJessica', 'secret', 'subscriber' ],
      [ 3, 'gurney', 'secret', 'subscriber']
    ]
  end
  let(:bookworms_csv_path) { 'spec/support/bookworms.csv' }
  let(:bookworm_repository) { BookwormRepository.new(bookworms_csv_path) }

  let(:recommendations) do
    [
      [ 'id', 'read', 'book_id', 'theme_id', 'bookworm_id' ],
      [ 1, true, 1, 1, 2 ],
      [ 2, false, 1, 2, 2 ],
      [ 3, false, 2, 3, 2 ],
      [ 4, false, 5, 2, 3 ]
    ]
  end
  let(:recommendations_csv_path) { 'spec/support/recommendations.csv' }
  let(:recommendation_repository) { RecommendationRepository.new(recommendations_csv_path, book_repository, theme_repository, bookworm_repository) }

  before(:each) do
    CsvHelper.write_csv(books_csv_path, books)
    CsvHelper.write_csv(bookworms_csv_path, bookworms)
    CsvHelper.write_csv(themes_csv_path, themes)
    CsvHelper.write_csv(recommendations_csv_path, recommendations)
  end

  it 'Should be initialized with 4 repository instances' do
    controller = RecommendationsController.new(book_repository, theme_repository, bookworm_repository, recommendation_repository)
    expect(controller).to be_a(RecommendationsController)
  end

  describe '#add' do
    it 'Should ask the user for a book index, a theme index and an bookworm index to be assigned' do
      controller = RecommendationsController.new(book_repository, theme_repository, bookworm_repository, recommendation_repository)
      allow_any_instance_of(Object).to receive(:gets).and_return('2')

      controller.add

      expect(recommendation_repository.unread_recommendations.length).to eq(4)
      expect(recommendation_repository.unread_recommendations[3].book.title).to eq('Title 2')
      expect(recommendation_repository.unread_recommendations[3].bookworm.username).to eq('gurney')
      expect(recommendation_repository.unread_recommendations[3].theme.name).to eq('theme 2')
    end
  end

  describe '#list_unread_recommendations' do
    it 'Should list unread recommendations (with book, bookworm assigned and theme info)' do
      controller = RecommendationsController.new(book_repository, theme_repository, bookworm_repository, recommendation_repository)
      recommendations.drop(2).each do |recommendation|
        expect($stdout).to receive(:puts).with(/#{theme_repository.find(recommendation[3]).name}/)
      end
      controller.list_unread_recommendations
    end
  end

  describe '#list_my_recommendations' do
    it 'Should take an Bookworm instance as a parameter' do
      expect(RecommendationsController.instance_method(:list_my_recommendations).arity).to eq(1)
    end

    it "Should list Gurney's unread recommendations" do
      controller = RecommendationsController.new(book_repository, theme_repository, bookworm_repository, recommendation_repository)
      gurney = bookworm_repository.find(3)
      expect($stdout).to receive(:puts).with(/(theme 1||Title 5).*(Title 5||theme 1)/)
      controller.list_my_recommendations(gurney)
    end
  end

  describe '#mark_as_read' do
    it 'Should take an Bookworm instance as a parameter' do
      expect(RecommendationsController.instance_method(:mark_as_read).arity).to eq(1)
    end

    it 'Should ask the subscriber for an recommendation index (of their unread recommendations), mark it as read, and save the relevant data to the CSV file' do
      controller = RecommendationsController.new(book_repository, theme_repository, bookworm_repository, recommendation_repository)
      # gurney wants to mark as read number 4.
      allow_any_instance_of(Object).to receive(:gets).and_return('1')
      gurney = bookworm_repository.find(3)  # gurney is a subscriber
      controller.mark_as_read(gurney)
      # Reload from CSV
      new_recommendation_repository = RecommendationRepository.new(recommendations_csv_path, book_repository, theme_repository, bookworm_repository)
      expect(new_recommendation_repository.unread_recommendations.map(&:id)).not_to include(4)
      # Rewrite the original CSV
      CsvHelper.write_csv(recommendations_csv_path, recommendations)
    end
  end
end
