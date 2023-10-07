require "fileutils"
require_relative "support/csv_helper"

begin
  require_relative "../app/models/theme"
  require_relative "../app/repositories/theme_repository"
  require_relative "../app/controllers/themes_controller"
rescue => exception
  raise e
end

describe "Theme", :theme do
  it "Should be initialized with a hash of properties" do
    properties = { id: 1, name: "trial theme", description: "A theme to test out all themes" }
    theme = Theme.new(properties)
    expect(theme).to be_a(Theme)
  end

  describe "#id" do
    it "Should return the theme id" do
      theme = Theme.new({ id: 42 })
      expect(theme.id).to eq(42)
    end
  end

  describe "#id=" do
    it "Should set the theme id" do
      theme = Theme.new({ id: 42 })
      theme.id = 43
      expect(theme.id).to eq(43)
    end
  end

  describe "#name" do
    it "Should return the name of the Theme" do
      theme = Theme.new({ name: "Fun fiction" })
      expect(theme.name).to eq("Fun fiction")
    end
  end

  describe "#description" do
    it "Should return the theme description" do
      theme = Theme.new({ description: "This theme will knock your socks off, and you'll be happy it did!" })
      expect(theme.description).to eq("This theme will knock your socks off, and you'll be happy it did!")
    end
  end
end

describe "ThemeRepository", :theme do
  let(:themes) do
    [
      [ "id", "name", "description" ],
      [ 1, "theme 1", "A nice little theme with cool books in it" ],
      [ 2, "theme 2", "A nice little theme with cool books in it" ],
      [ 3, "theme 3", "A nice little theme with cool books in it" ]
    ]
  end
  let(:csv_path) {"spec/support/themes.csv"}

  before(:each) do
    CsvHelper.write_csv(csv_path, themes)
  end

  def elements(repo)
    repo.instance_variable_get(:@themes) ||
      repo.instance_variable_get(:@elements)
  end

  describe "#initialize" do
    it "Should take one argument: the CSV file path to store themes" do
      expect(ThemeRepository.instance_method(:initialize).arity).to eq(1)
    end

    it "Should not crash if the CSV path does not exist yet" do
      expect { ThemeRepository.new("fake_file.csv") }.not_to raise_error
    end

    it "Should store themes in memory in an instance variable `@themes` or `@elements`" do
      repo = ThemeRepository.new(csv_path)
      expect(elements(repo)).to be_a(Array)
    end

    it "Should load existing themes from the CSV" do
      repo = ThemeRepository.new(csv_path)
      loaded_themes = elements(repo) || []
      expect(loaded_themes.length).to eq(3)
    end

    it "Should fill the `@themes` with instances of `Theme`, setting the correct types on each property" do
      repo = ThemeRepository.new(csv_path)
      loaded_themes = elements(repo) || []
      fail if loaded_themes.empty?
      loaded_themes.each do |theme|
        expect(theme).to be_a(Theme)
        expect(theme.id).to be_a(Integer)
      end
    end
  end

  describe "#create" do
    it "Should create a theme to the in-memory list" do
      repo = ThemeRepository.new(csv_path)
      new_theme = Theme.new(description: "Freeform storytelling", name: "Ditch the denoument")
      repo.create(new_theme)
      expect(repo.all.length).to eq(4)
    end

    it "Should set the new theme id" do
      repo = ThemeRepository.new(csv_path)
      silly_theme = Theme.new(description: "Books to make you laugh out loud", name: "Silly stuff")
      repo.create(silly_theme)
      expect(silly_theme.id).to eq(4)
      serious_theme = Theme.new(description: "Get wrapped up and taken away by these incredible tales of renown", name: "Sweeping sagas")
      repo.create(serious_theme)
      expect(serious_theme.id).to eq(5)
    end

    it "Should start auto-incremting at 1 if it is the first theme created" do
      csv_path = "fake_empty_themes.csv"
      FileUtils.remove_file(csv_path, force: true)

      repo = ThemeRepository.new(csv_path)
      silly_theme = Theme.new(description: "Books to make you laugh out loud", name: "Silly stuff")
      repo.create(silly_theme)
      expect(silly_theme.id).to eq(1)

      FileUtils.remove_file(csv_path, force: true)
    end

    it "Should save each new theme in the CSV" do
      csv_path = "spec/support/empty_themes.csv"
      FileUtils.remove_file(csv_path, force: true)

      repo = ThemeRepository.new(csv_path)
      silly_theme = Theme.new(description: "Books to make you laugh out loud", name: "Silly stuff")
      repo.create(silly_theme)

      repo = ThemeRepository.new(csv_path)
      expect(repo.all.length).to eq(1)
      expect(repo.all[0].id).to eq(1)
      expect(repo.all[0].name).to eq("Silly stuff")
      expect(repo.all[0].description).to eq("Books to make you laugh out loud")

      serious_theme = Theme.new(description: "Get wrapped up and taken away by these incredible tales of renown", name: "Sweeping sagas")
      repo.create(serious_theme)
      expect(serious_theme.id).to eq(2)

      repo = ThemeRepository.new(csv_path)
      expect(repo.all.length).to eq(2)
      expect(repo.all[1].id).to eq(2)
      expect(repo.all[1].name).to eq("Sweeping sagas")
      expect(repo.all[1].description).to eq("Get wrapped up and taken away by these incredible tales of renown")

      FileUtils.remove_file(csv_path, force: true)
    end
  end

  describe "#all" do
    it "Should return all the themes stored by the repo" do
      repo = ThemeRepository.new(csv_path)
      expect(repo.all).to be_a(Array)
      expect(repo.all[0].name).to eq("theme 1")
    end

    it "ThemeRepository should not expose the @themes through a reader/method" do
      repo = ThemeRepository.new(csv_path)
      expect(repo).not_to respond_to(:themes)
    end
  end

  describe "#find" do
    it "should retrieve a specific theme based on its id" do
      repo = ThemeRepository.new(csv_path)
      theme = repo.find(3)
      expect(theme.id).to eq(3)
      expect(theme.name).to eq("theme 3")
    end
  end
end

describe "ThemeController", :theme do
  let(:themes) do
    [
      [ "id", "name", "description" ],
      [ 1, "theme 1", "A nice little theme with cool books in it" ],
      [ 2, "theme 2", "A nice little theme with cool books in it" ],
      [ 3, "theme 3", "A nice little theme with cool books in it" ]
    ]
  end
  let(:csv_path) { "spec/support/themes.csv" }
  let(:repository) { ThemeRepository.new(csv_path) }

  before(:each) do
    CsvHelper.write_csv(csv_path, themes)
  end

  it "Should be initialized with a `ThemeRepository` instance" do
    controller = ThemesController.new(repository)
    expect(controller).to be_a(ThemesController)
  end

  describe "#add" do
    it "Should ask the user for a name and description, then store the new theme" do
      controller = ThemesController.new(repository)
      allow_any_instance_of(Object).to receive(:gets).and_return("new theme")

      controller.add

      expect(repository.all.length).to eq(4)
      expect(repository.all[3].name).to eq("new theme")
      expect(repository.all[3].description).to eq("new theme")
    end
  end

  describe "#list" do
    it "Should grab themes from the repo and display them" do
      controller = ThemesController.new(repository)
      themes.drop(1).each do |theme_array|
        expect(STDOUT).to receive(:puts).with(/#{theme_array[1]}/)
      end

      controller.list
    end
  end
end
