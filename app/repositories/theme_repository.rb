require 'csv'
require_relative '../models/theme'

class ThemeRepository
  def initialize(csv_file)
    @themes = []
    @csv_file = csv_file
    @next_id = 1
    load_csv
  end

  def all
    return @themes
  end

  def load_csv
    if File.exist?(@csv_file)
      CSV.foreach(@csv_file, headers: :first_row, header_converters: :symbol) do |row|
        row[:id] = row[:id].to_i
        row[:description] = row[:description]
        @themes << Theme.new(row)
      end
    end
    @next_id = @themes.last.id + 1 unless @themes.empty?
  end
end
