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

  def find(theme_id)
    @themes.each do |theme|
      return theme if theme.id == theme_id
    end
  end

  def create(theme)
    theme.id = @next_id
    @next_id += 1
    @themes << theme
    save_csv
  end

  def destroy(theme_index)
    @themes.delete_at(theme_index)
    save_csv
  end

  def save_csv
    CSV.open(@csv_file, "wb", :write_headers => true, :headers => ["id", "name", "description"]) do |row|
      @themes.each do |theme|
        row << [theme.id, theme.name, theme.description]
      end
    end
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
