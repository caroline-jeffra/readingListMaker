

begin
  require_relative "../app/models/book"
  require_relative "../app/models/theme"
  require_relative "../app/models/bookworm"
  require_relative "../app/models/group"
rescue => exception
  raise e
end

describe "Group", :_group do
  describe "#initialize" do
    it "Takes a hash of attributes as a parameter" do
      properties = { id: 1, read: false }
      group = Group.new(properties)
      expect(group).to be_a(Group)
    end

    it "Receives the :book attribute, which is an instance of Book" do
      properties = { book: Book.new({}) }
      group = Group.new(properties)
      expect(group.instance_variable_get(:@book)).to be_a(Book)
    end

    it "Receives the :theme attribute, which is an instance of Theme" do
      properties = { theme: Theme.new({}) }
      group = Group.new(properties)
      expect(group.instance_variable_get(:@theme)).to be_a(Theme)
    end

    it "Receives the :bookworm attribute, which is an instance of Bookworm" do
      properties = { bookworm: Bookworm.new({}) }
      group = Group.new(properties)
      expect(group.instance_variable_get(:@bookworm)).to be_a(Bookworm)
    end

  end

  describe "#id" do
    it "Should return the group id" do
      group = Group.new(id: 42)
      expect(group.id).to eq(42)
    end
  end

  describe "#id=" do
    it "Should set the group id" do
      group = Group.new(id: 42)
      group.id = 43
      expect(group.id).to eq(43)
    end
  end

  describe "#read?" do
    it "Should return true if the group has been read" do
      group = Group.new(read: true)
      expect(group.read?).to be true
    end

    it "Should return false if the group has not yet been read" do
      group = Group.new({})
      expect(group.read?).to be false
    end
  end

  describe "#book" do
    it "Should return the book associated with the group" do
      group = Group.new(book: Book.new({}))
      expect(group.book).to be_a(Book)
    end
  end

  describe "#bookworm" do
    it "Should return the bookworm associated with the group" do
      group = Group.new(bookworm: Bookworm.new({}))
      expect(group.bookworm).to be_a(Bookworm)
    end
  end

  describe "#theme" do
    it "Should return the theme associated with the group" do
      group = Group.new(theme: Theme.new({}))
      expect(group.theme).to be_a(Theme)
    end
  end

  describe "#read!" do
    it "Should mark an group as read" do
      group = Group.new(id: 12)
      expect(group.read?).to be false
      group.read!
      expect(group.read?).to be true
    end
  end
end
