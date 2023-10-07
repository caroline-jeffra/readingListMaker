require_relative '../models/book'
require_relative '../views/book_view'

class BooksController
  def initialize(book_repository)
    @book_repository = book_repository
    @book_view = BookView.new
  end

  def add
    new_book = @book_view.add
    book = Book.new(new_book)
    @book_repository.create(book)
  end

  def list
    books = @book_repository.all
    @book_view.display_list(books)
  end

  def edit
    list
    selection_index = @book_view.edit_choice
    updated_values = @book_view.make_edit
    edit_book = @book_repository.all[selection_index]
    edit_book.title = updated_values[:title]
    edit_book.author = updated_values[:author]
    edit_book.genre = updated_values[:genre]
    edit_book.description = updated_values[:description]
    edit_book.isbn = updated_values[:isbn]
  end

  def remove
    list
    @book_repository.destroy[@book_view.remove]
  end
end
