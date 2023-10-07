begin
  require_relative "../app/models/theme"
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
