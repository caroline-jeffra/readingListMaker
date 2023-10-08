require 'csv'
require_relative '../models/book'

class BookRepository
  def initialize(csv_file)
    @books = []
    @csv_file = csv_file
    @next_id = 1
    load_csv
  end

  def all
    return @books
  end

  def find(book_id)
    @books.find { |book| book.id == book_id }
  end

  def create(book)
    book.id = @next_id
    @next_id += 1
    @books << book
    save_csv
  end

  def destroy(book_index)
    @books.delete_at(book_index)
    save_csv
  end

  private

  def save_csv
    CSV.open(@csv_file, "wb", :write_headers => true, :headers => ["id", "title", "author", "genre", "description", "isbn"]) do |row|
      @books.each do |book|
        row << [book.id, book.title, book.author, book.genre, book.description, book.isbn]
      end
    end
  end

  def load_csv
    if File.exist?(@csv_file)
      CSV.foreach(@csv_file, headers: :first_row, header_converters: :symbol) do |row|
        row[:id] = row[:id].to_i
        row[:isbn] = row[:isbn].to_i
        @books << Book.new(row)
      end
    end
    @next_id = @books.last.id + 1 unless @books.empty?
  end
end
