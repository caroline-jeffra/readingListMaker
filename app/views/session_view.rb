class SessionView
  def welcome(username)
    puts "\nWelcome, #{username}. You have successfullly logged in.\n"
  end

  def ask_for(thing)
    puts "Please enter your #{thing}"
    return gets.chomp
  end

  def display_all(bookworms)
    bookworms.each_with_index do |bookworm, index|
      puts "#{index + 1}. #{bookworm.username}"
    end
  end

  def display_subscribers(subscribers)
    subscribers.each_with_index do |subscriber, i|
      puts "#{i + 1} - #{subscriber.username}"
    end
  end

  def wrong_credentials
    puts "Wrong credentials! Please try again."
  end
end
