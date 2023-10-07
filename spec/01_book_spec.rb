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
      name: "The Color of Magic",
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

  describe "#name" do
    it "Should return the name of the book" do
      book = Book.new({ name: "The Hitchhiker's Guide to the Galaxy" })
      expect(book.name).to eq("The Hitchhiker's Guide to the Galaxy")
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
