class Book
  attr_accessor :name, :author, :genre, :description, :isbn

  def initialize(attributes = {})
    @id = attributes[:id]
    @name = attributes[:name]
    @author = attributes[:author]
    @genre = attributes[:genre]
    @description = attributes[:description]
    @isbn = attributes[:isbn]
  end
end
