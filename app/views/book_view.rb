class BookView
  def display_list(books)
    books.each_with_index do |book, index|
      puts "#{index + 1} - #{book.name}"
    end
  end

  def add
    puts "Book title:"
    title = gets.chomp

    puts "Book author (ex: Ursula Le Guin): "
    author = gets.chomp

    puts "Book genre: "
    genre = gets.chomp

    puts "Book description: "
    description = gets.chomp

    puts "Book ISBN: "
    isbn = gets.chomp

    return { title: title, author: author, genre: genre, description: description, isbn: isbn}
  end

  def edit_choice
    puts "Which book would you like to edit?"
    return gets.chomp.to_i - 1
  end

  def make_edit
    puts "Correct book title:"
    title = gets.chomp

    puts "Correct book author (ex: Ursula Le Guin): "
    author = gets.chomp

    puts "Correct book genre: "
    genre = gets.chomp

    puts "Correct book description: "
    description = gets.chomp

    puts "Correct book ISBN: "
    isbn = gets.chomp

    return { title: title, author: author, genre: genre, description: description, isbn: isbn}
  end

  def remove
    puts "Which book would you like to remove? Enter an index number:"
    return gets.chompe.to_i - 1
  end
end
