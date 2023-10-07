require 'csv'
require_relative '../models/group'

class GroupRepository
  def initialize(groups_csv_path, book_repository, theme_repository, bookworm_repository)
    @groups_csv = groups_csv_path
    @book_repository = book_repository
    @theme_repository = theme_repository
    @bookworm_repository = bookworm_repository

    @groups = []
    @next_id = 1

    load_csv if File.exist?(@groups_csv)
  end

  def create(group)
    group.id = @next_id
    @next_id += 1
    @groups << group
    save_csv
  end

  def unread_groups
    @groups.reject { |group| group.read? }
  end

  def my_unread_groups(rider)
    unread_groups.select { |group| group.bookworm == rider }
  end

  def update_mark(group)
    group.read!
    save_csv
  end

  private

  def load_csv
    CSV.foreach(@groups_csv, headers: :first_row, header_converters: :symbol) do |row|
      row[:id] = row[:id].to_i
      row[:read] = row[:read] == "true"
      row[:book] = @book_repository.find(row[:book_id].to_i)
      row[:theme] = @theme_repository.find(row[:theme_id].to_i)
      row[:bookworm] = @bookworm_repository.find(row[:bookworm_id].to_i)
      @groups << Group.new(row)
    end
    @next_id = @groups.last.id + 1 unless @groups.empty?
  end

  def save_csv
    headers_array = ["id", "read", "book_id", "theme_id", "bookworm_id"]
    CSV.open(@groups_csv, "wb", :write_headers => true, :headers => headers_array) do |row|
      @groups.each do |group|
        id = group.id
        read = group.read?
        book_id = group.book.id
        theme_id = group.theme.id
        bookworm_id = group.bookworm.id
        row << [id, read, book_id, theme_id, bookworm_id]
      end
    end
  end
end
