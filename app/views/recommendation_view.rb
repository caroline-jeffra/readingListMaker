class RecommendationView
  def ask_index
    puts "Index?"
    print "> "
    gets.chomp.to_i - 1
  end

  def display(recommendations)
    recommendations.each_with_index do |recommendation, index|
      puts "#{index + 1}. #{recommendation.bookworm.username} must deliver #{recommendation.book.title} to #{recommendation.theme.name}"
    end
  end
end
