class GroupView
  def ask_index
    puts "Index?"
    print "> "
    gets.chomp.to_i - 1
  end

  def display(groups)
    groups.each_with_index do |group, index|
      puts "#{index + 1}. #{group.bookworm.username} must deliver #{group.book.title} to #{group.theme.name}"
    end
  end
end
