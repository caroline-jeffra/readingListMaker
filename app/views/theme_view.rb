class ThemeView
  def display_list(themes)
    themes.each_with_index do |theme, index|
      puts "#{index + 1} - #{theme.name}"
    end
  end

  def add
    puts "What is the name of the theme?"
    name = gets.chomp
    puts "What is the description of the theme?"
    description = gets.chomp
    return { name: name, description: description }
  end

  def edit_choice
    puts "Which theme do you wish to edit?"
    return gets.chomp.to_i - 1
  end

  def make_edit
    puts "What is the correct name?"
    name = gets.chomp
    puts "What is the correct description?"
    description = gets.chomp
    return [name, description]
  end

  def remove
    puts "Which theme would you like to remove? Enter a number."
    return gets.chomp.to_i - 1
  end
end
