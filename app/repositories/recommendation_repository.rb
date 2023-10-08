require 'csv'
require_relative '../models/recommendation'

class RecommendationRepository
  def initialize(recommendations_csv_path, book_repository, theme_repository, bookworm_repository)
    @recommendations_csv = recommendations_csv_path
    @book_repository = book_repository
    @theme_repository = theme_repository
    @bookworm_repository = bookworm_repository

    @recommendations = []
    @next_id = 1

    load_csv if File.exist?(@recommendations_csv)
  end

  def create(recommendation)
    recommendation.id = @next_id
    @next_id += 1
    @recommendations << recommendation
    save_csv
  end

  def unread_recommendations
    @recommendations.reject { |recommendation| recommendation.read? }
  end

  def my_unread_recommendations(bookworm)
    unread_recommendations.select { |recommendation| recommendation.bookworm == bookworm && !recommendation.read? }
  end

  def update_mark(recommendation)
    recommendation.read!
    save_csv
  end

  private

  def load_csv
    CSV.foreach(@recommendations_csv, headers: :first_row, header_converters: :symbol) do |row|
      row[:id] = row[:id].to_i
      row[:book] = @book_repository.find(row[:book_id].to_i)
      row[:theme] = @theme_repository.find(row[:theme_id].to_i)
      row[:bookworm] = @bookworm_repository.find(row[:bookworm_id].to_i)
      row[:read] = row[:read] == "true"
      @recommendations << Recommendation.new(row)
    end
    @next_id = @recommendations.last.id + 1 unless @recommendations.empty?
  end

  # this method is failing a test - undefined method error for recommendation.book.title
  def save_csv
    CSV.open(@recommendations_csv, "wb") do |row|
      row << %w[id book_id theme_id bookworm_id read]
      @recommendations.each do |recommendation|
        row << [recommendation.id, recommendation.book.id, recommendation.theme.id, recommendation.bookworm.id, recommendation.read?]
      end
    end
  end
end
