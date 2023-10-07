

begin
  require_relative "../app/models/bookworm"
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
