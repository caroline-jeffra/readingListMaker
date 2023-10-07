class Book
  attr_accessor :id, :title, :author, :genre, :description, :isbn

  def initialize(attributes = {})
    @id = attributes[:id]
    @title = attributes[:title]
    @author = attributes[:author]
    @genre = attributes[:genre]
    @description = attributes[:description]
    @isbn = attributes[:isbn]
  end
end
