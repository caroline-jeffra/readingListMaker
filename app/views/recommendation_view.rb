class RecommendationView
  def ask_index
    puts "Index?"
    print "> "
    gets.chomp.to_i - 1
  end

  def display(recommendations)
    recommendations.each_with_index do |recommendation, index|
      puts "#{index + 1}. #{recommendation.bookworm.username} was recommended '#{recommendation.book.title}' in the theme '#{recommendation.theme.name}'"
    end
  end
end
