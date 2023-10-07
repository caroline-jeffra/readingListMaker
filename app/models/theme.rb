class Theme
  attr_accessor :name, :description, :id

  def initialize(attributes = {})
    @id = attributes[:id]
    @name = attributes[:name]
    @description = attributes[:description]
  end
end
