require 'csv'
require_relative '../models/bookworm'

class BookwormRepository
  def initialize(csv_file)
    @csv_file = csv_file
    @bookworms = []
    @next_id = 1
    load_csv if File.exist?(@csv_file)
  end

  def all_subscribers
    return @bookworms.select { |bookworm| bookworm.subscriber? }
  end

  def find(id)
    return @bookworms.find { |bookworm| bookworm.id == id }
  end

  def find_by_username(username)
    @bookworms.find { |bookworm| bookworm.username == username }
  end

  private

  def load_csv
    CSV.foreach(@csv_file, headers: :first_row, header_converters: :symbol) do |row|
      row[:id] = row[:id].to_i
      @bookworms << Bookworm.new(row)
    end
    @next_id = @bookworms.last.id + 1 unless @bookworms.empty?
  end
end
