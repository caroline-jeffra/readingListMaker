require_relative "../views/book_view"
require_relative "../views/theme_view"
require_relative "../views/session_view"
require_relative "../views/group_view"

class GroupsController
  def initialize(book_repository, theme_repository, bookworm_repository, group_repository)
    @book_repository = book_repository
    @theme_repository = theme_repository
    @bookworm_repository = bookworm_repository
    @group_repository = group_repository

    @books_view = BookView.new
    @themes_view = ThemeView.new
    @sessions_view = SessionView.new
    @groups_view = GroupView.new
  end

  def add
    books = @book_repository.all
    @books_view.display_list(books)
    book_id = @groups_view.ask_index
    book = books[book_id]

    themes = @theme_repository.all
    @themes_view.display_list(themes)
    theme_id = @groups_view.ask_index
    theme = themes[theme_id]

    bookworms = @bookworm_repository.all_subscribers
    @sessions_view.display_subscribers(bookworms)
    bookworm_id = @groups_view.ask_index
    bookworm = bookworms[bookworm_id]

    group = Group.new(book: book, theme: theme, bookworm: bookworm)
    @group_repository.create(group)
  end

  def list_unread_groups
    groups = @group_repository.unread_groups
    @groups_view.display(groups)
  end

  def list_my_groups(rider)
    display_unread(rider)
  end

  def mark_as_read(rider)
    groups = display_unread(rider)
    index = @groups_view.ask_index
    group = groups[index]
    @group_repository.update_mark(group)
  end

  private

  def display_unread(rider)
    groups = @group_repository.my_unread_groups(rider)
    @groups_view.display(groups)
    return groups
  end
end
