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
