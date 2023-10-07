require "fileutils"

begin
  require_relative "../app/models/book"
  require_relative "../app/models/theme"
  require_relative "../app/models/bookworm"
  require_relative "../app/models/group"
  require_relative "../app/repositories/book_repository"
  require_relative "../app/repositories/theme_repository"
  require_relative "../app/repositories/bookworm_repository"
  require_relative "../app/repositories/group_repository"
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

describe "GroupRepository", :_group do
  let(:book) do
    [
      [ "id", "name", "price" ],
      [ 1, "Margherita", 8 ],
      [ 2, "Capricciosa", 11 ],
      [ 3, "Napolitana", 9 ],
      [ 4, "Funghi", 12 ],
      [ 5, "Calzone", 10 ]
    ]
  end
  let(:book_csv_path) { "spec/support/book.csv" }
  let(:book_repository) { BookRepository.new(book_csv_path) }

  let(:themes) do
    [
      [ "id", "name", "description" ],
      [ 1, "theme 1", "A nice little theme with cool books in it" ],
      [ 2, "theme 2", "A nice little theme with cool books in it" ],
      [ 3, "theme 3", "A nice little theme with cool books in it" ]
    ]
  end
  let(:themes_csv_path) { "spec/support/themes.csv" }
  let(:theme_repository) { ThemeRepository.new(themes_csv_path) }

  let(:bookworms) do
    [
      [ "id", "username", "password", "role" ],
      [ 1, "paulAtreides", "secret", "manager" ],
      [ 2, "ladyJessica", "secret", "subscriber" ],
      [ 3, "gurney", "secret", "subscriber"]
    ]
  end
  let(:bookworms_csv_path) { "spec/support/bookworms.csv" }
  let(:bookworm_repository) { BookwormRepository.new(bookworms_csv_path) }

  let(:groups) do
    [
      [ "id", "read", "book_id", "theme_id", "bookworm_id"],
      [ 1, true, 1, 1, 2 ],
      [ 2, false, 1, 2, 2 ],
      [ 3, false, 2, 3, 2 ],
    ]
  end
  let(:groups_csv_path) { "spec/support/groups.csv" }
  let(:group_repository) { GroupRepository.new(groups_csv_path) }

  before(:each) do
    CsvHelper.write_csv(book_csv_path, book)
    CsvHelper.write_csv(themes_csv_path, themes)
    CsvHelper.write_csv(bookworms_csv_path, bookworms)
    CsvHelper.write_csv(groups_csv_path, groups)
  end

  def elements(repo)
    repo.instance_variable_get(:@groups) ||
      repo.instance_variable_get(:@elements)
  end

  describe "#initialize" do
    it "should take 4 arguments: the CSV file path to store groups, and 3 repository instances (book, theme and bookworm)" do
      expect(GroupRepository.instance_method(:initialize).arity).to eq(4)
    end

    it "should not crash if the CSV path does not exist yet" do
      expect { GroupRepository.new("fake_file.csv", book_repository, theme_repository, bookworm_repository) }.not_to raise_error
    end

    it "store the 3 auxiliary repositories in instance variables" do
      repo = GroupRepository.new(groups_csv_path, book_repository, theme_repository, bookworm_repository)
      expect(repo.instance_variable_get(:@book_repository)).to be_a(BookRepository)
      expect(repo.instance_variable_get(:@theme_repository)).to be_a(ThemeRepository)
      expect(repo.instance_variable_get(:@bookworm_repository)).to be_a(BookwormRepository)
    end

    it "store groups in memory in an instance variable `@groups` or `@elements`" do
      repo = GroupRepository.new(groups_csv_path, book_repository, theme_repository, bookworm_repository)
      expect(elements(repo)).to be_a(Array)
    end

    it "should load existing groups from the CSV" do
      repo = GroupRepository.new(groups_csv_path, book_repository, theme_repository, bookworm_repository)
      loaded_groups = elements(repo) || []
      expect(loaded_groups.length).to eq(3)
    end

    it "should fill the `@groups` or `@elements` array of groups with instance of `Group`, setting the correct types on each property" do
      repo = GroupRepository.new(groups_csv_path, book_repository, theme_repository, bookworm_repository)
      loaded_groups = elements(repo) || []
      fail if loaded_groups.empty?
      loaded_groups.each do |group|
        expect(group).to be_a(Group)
        expect(group.book).to be_a(Book)
        expect(group.bookworm).to be_a(Bookworm)
        expect(group.theme).to be_a(Theme)
      end
      expect(loaded_groups[0].instance_variable_get(:@read)).to be true
      expect(loaded_groups[1].instance_variable_get(:@read)).to be false
      expect(loaded_groups[2].instance_variable_get(:@read)).to be false
    end
  end

  describe "#create" do
    it "should add an group to the in-memory list" do
      repo = GroupRepository.new(groups_csv_path, book_repository, theme_repository, bookworm_repository)
      new_group = Group.new({
        book: book_repository.find(1),
        theme: theme_repository.find(1),
        bookworm: bookworm_repository.find(1)
      })
      repo.create(new_group)
      expect(elements(repo).length).to eq(4)
    end

    it "should set the new group id" do
      repo = GroupRepository.new(groups_csv_path, book_repository, theme_repository, bookworm_repository)
      new_group = Group.new({
        book: book_repository.find(1),
        theme: theme_repository.find(1),
        bookworm: bookworm_repository.find(1)
      })
      repo.create(new_group)
      expect(new_group.id).to eq(4)
    end

    it "should start auto-incrementing at 1 if it is the first group added" do
      groups_csv_path = "fake_empty_groups.csv"
      FileUtils.remove_file(groups_csv_path, force: true)

      repo = GroupRepository.new(groups_csv_path, book_repository, theme_repository, bookworm_repository)
      new_group = Group.new({
        book: book_repository.find(1),
        theme: theme_repository.find(1),
        bookworm: bookworm_repository.find(1)
      })
      repo.create(new_group)
      expect(new_group.id).to eq(1)

      FileUtils.remove_file(groups_csv_path, force: true)
    end

    it "should save each new group in the CSV" do
      groups_csv_path = "spec/support/empty_groups.csv"
      FileUtils.remove_file(groups_csv_path, force: true)

      repo = GroupRepository.new(groups_csv_path, book_repository, theme_repository, bookworm_repository)
      new_group = Group.new({
        book: book_repository.find(1),
        theme: theme_repository.find(1),
        bookworm: bookworm_repository.find(1)
      })
      repo.create(new_group)

      repo = GroupRepository.new(groups_csv_path, book_repository, theme_repository, bookworm_repository)
      expect(repo.unread_groups.length).to eq(1)
      expect(repo.unread_groups[0].id).to eq(1)
      expect(repo.unread_groups[0].book).to be_a(Book)
      expect(repo.unread_groups[0].book.id).to eq(1)
      expect(repo.unread_groups[0].bookworm).to be_a(Bookworm)
      expect(repo.unread_groups[0].bookworm.id).to eq(1)
      expect(repo.unread_groups[0].theme).to be_a(Theme)
      expect(repo.unread_groups[0].theme.id).to eq(1)

      FileUtils.remove_file(groups_csv_path, force: true)
    end
  end

  describe "#unread_groups" do
    it "should return all the unread groups" do
      repo = GroupRepository.new(groups_csv_path, book_repository, theme_repository, bookworm_repository)
      expect(repo.unread_groups).to be_a(Array)
      expect(repo.unread_groups.length).to eq(2)
      expect(repo.unread_groups[0]).to be_a(Group)
      expect(repo.unread_groups[1]).to be_a(Group)
      expect(repo.unread_groups[0].read?).to be false
      expect(repo.unread_groups[1].read?).to be false
    end

    it "GroupRepository should not expose the @groups through a reader/method" do
      repo = GroupRepository.new(groups_csv_path, book_repository, theme_repository, bookworm_repository)
      expect(repo).not_to respond_to(:groups)
    end
  end
end
