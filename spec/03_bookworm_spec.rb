require "fileutils"
require_relative "support/csv_helper"

begin
  require_relative "../app/models/bookworm"
  require_relative "../app/repositories/bookworm_repository"
rescue => exception
  raise e
end

describe "Bookworm", :bookworm do
  it "Should be initialized with a hash of properties" do
    properties = { id: 1, username: "paulAtriedes", password: "secret", role: "recommender" }
    bookworm = Bookworm.new(properties)
    expect(bookworm).to be_a(Bookworm)
  end

  describe "#id" do
    it "Should return the bookworm id" do
      bookworm = Bookworm.new({ id: 42 })
      expect(bookworm.id).to eq(42)
    end
  end

  describe "#id=" do
    it "Should set the bookworm id" do
      bookworm = Bookworm.new({ id: 42 })
      bookworm.id = 43
      expect(bookworm.id).to eq(43)
    end
  end

  describe "#username" do
    it "Should return the username of the bookworm" do
      bookworm = Bookworm.new({ username: "paulAtriedes" })
      expect(bookworm.username).to eq("paulAtriedes")
    end
  end

  describe "#password" do
    it "Should return the password of the bookworm" do
      bookworm = Bookworm.new({ password: "secret" })
      expect(bookworm.password).to eq("secret")
    end
  end

  describe "#role" do
    it "Should return the role of the bookworm" do
      bookworm = Bookworm.new({ role: "subscriber" })
      expect(bookworm.role).to eq("subscriber")
    end
  end

  describe "#recommender?" do
    it "Should return true if the bookworm is a recommender" do
      bookworm = Bookworm.new({ role: "recommender" })
      expect(bookworm.recommender?).to be true
    end

    it "Should return false if the bookworm is a subscriber" do
      bookworm = Bookworm.new({ role: "subscriber" })
      expect(bookworm.recommender?).to be false
    end
  end

  describe "#subscriber?" do
    it "Should return true if the bookworm is a subscriber" do
      bookworm = Bookworm.new({ role: "subscriber" })
      expect(bookworm.subscriber?).to be true
    end

    it "Should return false if the bookworm is a recommender" do
      bookworm = Bookworm.new({ role: "recommender" })
      expect(bookworm.subscriber?).to be false
    end
  end
end

describe "BookwormRepository", :bookworm do
  let(:bookworms) do
    [
      [ "id", "username", "password", "role" ],
      [ 1, "paulAtreides", "secret", "manager" ],
      [ 2, "ladyJessica", "secret", "subscriber" ],
      [ 3, "gurney", "secret", "subscriber"]
    ]
  end
  let(:csv_path) { "spec/support/bookworms.csv" }

  before(:each) do
    CsvHelper.write_csv(csv_path, bookworms)
  end

  def elements(repo)
    repo.instance_variable_get(:@bookworms) ||
      repo.instance_variable_get(:@elements)
  end

  describe "#initialize" do
    it "Should take one argument: the CSV file path to store bookworms" do
      expect(BookwormRepository.instance_method(:initialize).arity).to eq(1)
    end

    it "Should not crash if the CSV path does not exist yet" do
      expect { BookwormRepository.new("fake_file.csv") }.not_to raise_error
    end

    it "Should store bookworms in memory in an instance variable `@bookworms`" do
      repo = BookwormRepository.new(csv_path)
      expect(elements(repo)).to be_a(Array)
    end

    it "Should load existing bookworms from the CSV" do
      repo = BookwormRepository.new(csv_path)
      loaded_bookworms = elements(repo) || []
      expect(loaded_bookworms.length).to eq(3)
    end

    it "Fills the `@bookworms` with instance of `Bookworm`, setting the correct types on each property" do
      repo = BookwormRepository.new(csv_path)
      loaded_bookworms = elements(repo) || []
      fail if loaded_bookworms.empty?
      loaded_bookworms.each do |bookworm|
        expect(bookworm).to be_a(Bookworm)
        expect(bookworm.id).to be_a(Integer)
        expect(bookworm.username).not_to be_empty
        expect(bookworm.password).not_to be_empty
        expect(bookworm.role).not_to be_empty
      end
    end
  end

  it "BookwormRepository should not implement a create method" do
    repo = BookwormRepository.new(csv_path)
    expect(repo).not_to respond_to(:create)
  end

  describe "#all_subscribers" do
    it "Should return all the subscribers stored by the repo" do
      repo = BookwormRepository.new(csv_path)
      expect(repo.all_subscribers).to be_a(Array)
      expect(repo.all_subscribers.size).to eq(2)
      expect(repo.all_subscribers[0].username).to eq("ladyJessica")
    end

    it "BookwormRepository should not expose the @bookworms through a reader/method" do
      repo = BookwormRepository.new(csv_path)
      expect(repo).not_to respond_to(:bookworms)
    end
  end

  describe "#find" do
    it "Should retrieve a specific bookworm based on its id" do
      repo = BookwormRepository.new(csv_path)
      bookworm = repo.find(1)
      expect(bookworm.id).to eq(1)
      expect(bookworm.username).to eq("paulAtreides")
    end
  end

  describe "#find_by_username" do
    it "Should retrieve a specific bookworm based on its username" do
      repo = BookwormRepository.new(csv_path)
      bookworm = repo.find_by_username("ladyJessica")
      expect(bookworm).not_to be_nil
      expect(bookworm.id).to eq(2)
      expect(bookworm.username).to eq("ladyJessica")
    end
  end
end
