require "fileutils"
require_relative "support/csv_helper"

begin
  require_relative "../app/models/book"
  require_relative "../app/controllers/books_controller"
  require_relative "../app/repositories/book_repository"
  require_relative "../app/views/book_view"
rescue => exception
  raise e
end

describe "Book", :book do
  it "Should successfully initialize with hash of properties" do
    properties = {
      id: 1,
      title: "The Color of Magic",
      author: "Terry Pratchett",
      genre: "Fantasy",
      description: "In a world supported on the back of a giant turtle (sex unknown), a gleeful, explosive, wickedly eccentric expedition sets out. There's an avaricious but inept wizard, a naive tourist whose luggage moves on hundreds of dear little legs, dragons who only exist if you believe in them, and of course THE EDGE of the planet...",
      isbn: 9780060855925
    }
    book = Book.new(properties)
    expect(book).to be_a(Book)
  end

  describe "#id" do
    it "Should return book id" do
      book = Book.new({ id: 42 })
      expect(book.id).to eq(42)
    end
  end

  describe "#id=" do
    it "Should set book id" do
      book = Book.new({ id: 42 })
      book.id = 43
      expect(book.id).to eq(43)
    end
  end

  describe "#title" do
    it "Should return the title of the book" do
      book = Book.new({ title: "The Hitchhiker's Guide to the Galaxy" })
      expect(book.title).to eq("The Hitchhiker's Guide to the Galaxy")
    end
  end

  describe "#author" do
    it "Should return the name of the author" do
      book = Book.new({ author: "Philip K. Dick" })
      expect(book.author).to eq("Philip K. Dick")
    end
  end

  describe "#genre" do
    it "Should return the genre" do
      book = Book.new({ genre: "Science Fiction" })
      expect(book.genre).to eq("Science Fiction")
    end
  end

  describe "#description" do
    it "Should return the description" do
      book = Book.new({ description: "Set in the fictional world of Earthsea, The Tombs of Atuan follows the story of Tenar, a young girl born in the Kargish empire, who is taken while still a child to be the high priestess to the 'Nameless Ones' at the Tombs of Atuan." })
      expect(book.description).to eq("Set in the fictional world of Earthsea, The Tombs of Atuan follows the story of Tenar, a young girl born in the Kargish empire, who is taken while still a child to be the high priestess to the 'Nameless Ones' at the Tombs of Atuan.")
    end
  end

  describe "#isbn" do
    it "Should return the ISBN" do
      book = Book.new( isbn: 9780575094185)
      expect(book.isbn).to eq(9780575094185)
    end
  end
end

describe "BookRepository", :book do
  let(:books) do
    [
      ["id", "title", "author", "genre", "description", "isbn"],
      [ 1, "Title 1", "Author 1", "Genre 1", "description text for title 1", 9780575094185],
      [ 2, "Title 2", "Author 2", "Genre 2", "description text for title 2", 9780575094186],
      [ 3, "Title 3", "Author 3", "Genre 3", "description text for title 3", 9780575094187]
    ]
  end
  let(:csv_path) { "spec/support/books.csv" }

  before(:each) do
    CsvHelper.write_csv(csv_path, books)
  end

  def elements(repo)
    repo.instance_variable_get(:books) ||
      repo.instance_variable_get(:elements)
  end

  describe "#initialize" do
    it "Should take one argument: the CSV file path to store books" do
      expect(BookRepository.instance_method(:initialize).arity).to eq(1)
    end

    it "Should not crash if CSV path does not exist yet" do
      expect{ BookRepository.new("fake_file.csv") }.not_to raise_error
    end

    it "Should store books in memory in an instance variable `@books` or `@elements`" do
      repo = BookRepository.new(csv_path)
      expect(elements(repo)).to be_a(Array)
    end

    it "Loads existing books from the CSV" do
      repo = BookRepository.new(csv_path)
      loaded_books = elements(repo) || []
      expect(loaded_books.length).to eq(3)
    end

    it "Fill the `@books` with instance of `Book`, setting the correct types on each property" do
      repo = BookRepository.new(csv_path)
      loaded_books = elements(repo) || []
      fail if loaded_books.empty?
      loaded_books.each do |book|
        expect(book).to be_a(Book)
        expect(book.id).to be_a(Integer)
        expect(book.title).to be_a(String)
        expect(book.author).to be_a(String)
        expect(book.genre).to be_a(String)
        expect(book.description).to be_a(String)
        expect(book.isbn).to be_a(Integer)
      end
    end
  end

  describe "#create" do
    it "Should create a book to the in-memory list" do
      repo = BookRepository.new(csv_path)
      new_book = Book.new(title: "Title 4", author: "Author Name", genre: "Fiction", description: "It's a very short book about nothing at all!", isbn: 21345678910)
      repo.create(new_book)
      expect(repo.all.length).to eq(4)
    end

    it "Should set the new book id" do
      repo = BookRepository.new(csv_path)
      silly_book = Book.new(title: "Japes for the Genteel", author: "Bertie Worcester", genre: "Comedy", description: "What a silly book this is", isbn: 21345678910)
      repo.create(silly_book)
      expect(silly_book.id).to eq(4)
      serious_book = Book.new(title: "Topics for Serious Thought", author: "Leo Tolstoy", genre: "Drama", description: "What a serious book this is", isbn: 21345678911)
      repo.create(serious_book)
      expect(serious_book.id).to eq(5)
    end

    it "Should start auto-incrementing at 1 if it is the first book created" do
      csv_path = "fake_empty_books.csv"
      FileUtils.remove_file(csv_path, force: true)

      repo = BookRepository.new(csv_path)
      silly_book = Book.new(title: "Japes for the Genteel", author: "Bertie Worcester", genre: "Comedy", description: "What a silly book this is", isbn: 21345678910)
      repo.create(silly_book)
      expect(silly_book.id).to eq(1)

      FileUtils.remove_file(csv_path, force: true)
    end

    it "Every newly created book should be saved in a row in the CSV" do
      csv_path = "spec/support/empty_books.csv"
      FileUtils.remove_file(csv_path, force: true)

      silly_book = Book.new(title: "Japes for the Genteel", author: "Bertie Worcester", genre: "Comedy", description: "What a silly book this is", isbn: 21345678910)
      repo.create(silly_book)

      repo = BookRepository.new(csv_path)
      expect(repo.all.length).to eq(1)
      expect(repo.all[0].id).to eq(1)
      expect(repo.all[0].title).to eq("Japes for the Genteel")
      expect(repo.all[0].author).to eq("Bertie Worcester")
      expect(repo.all[0].genre).to eq("Comedy")
      expect(repo.all[0].description).to eq("What a silly book this is")
      expect(repo.all[0].isbn).to eq(21345678910)

      serious_book = Book.new(title: "Topics for Serious Thought", author: "Leo Tolstoy", genre: "Drama", description: "What a serious book this is", isbn: 21345678911)
      repo.create(serious_book)
      expect(serious_book.id).to eq(2)

      repo = MealRepository.new(csv_path)
      expect(repo.all.length).to eq(2)
      expect(repo.all[1].title).to eq("Topics for Serious Thought")
      expect(repo.all[1].author).to eq("Leo Tolstoy")
      expect(repo.all[1].genre).to eq("Drama")
      expect(repo.all[1].description).to eq("What a serious book this is")
      expect(repo.all[1].isbn).to eq(21345678911)

      FileUtils.remove_file(csv_path, force: true)
    end
  end

  describe "#all" do
    it "Should return all the books stored by the repo" do
      repo = BookRepository.new(csv_path)
      expect(repo.all).to be_a(Array)
      expect(repo.all[0].name).to eq("Title 1")
    end

    it "BookRepository should not expose the @books through a reader/method" do
      repo = BookRepository.new(csv_path)
      expect(repo).not_to respond_to(:books)
    end
  end

  describe "#find" do
    it "Should retrieve a specific book based on its id" do
      repo = BookRepository.new(csv_path)
      book = book.find(2)
      expect(book.id).to eq(2)
      expect(book.title).to eq("Title 2")
    end
  end
end
