class Recommendation
  attr_accessor :id
  attr_reader :book, :theme, :bookworm

  def initialize(attrs = {})
    @id = attrs[:id]
    @book = attrs[:book]
    @theme = attrs[:theme]
    @bookworm = attrs[:bookworm]
    @read = attrs[:read] || false
  end

  def read?
    return @read
  end

  def read!
    @read = true
  end
end
