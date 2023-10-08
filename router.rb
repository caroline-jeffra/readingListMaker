class Router
  def initialize(books_controller, themes_controller, sessions_controller, recommendations_controller)
    @books_controller     = books_controller
    @themes_controller = themes_controller
    @sessions_controller  = sessions_controller
    @recommendations_controller    = recommendations_controller
    @running = true
  end

  def run
    while @running
      @current_user = @sessions_controller.login
      @current_user.recommender? ? route_recommender_action : route_subscriber_action while @current_user
      print `clear`
    end
  end

  private

  def route_recommender_action
    print_recommender_menu
    choice = gets.chomp.to_i
    print `clear`
    recommender_action(choice)
  end

  def route_subscriber_action
    print_subscriber_menu
    choice = gets.chomp.to_i
    print `clear`
    subscriber_action(choice)
  end

  # rubocop:disable Metrics/MethodLength
  def print_recommender_menu
    puts "--------------------"
    puts "------- MENU -------"
    puts "--------------------"
    puts "1. Add new book"
    puts "2. List all books"
    puts "3. Add new theme"
    puts "4. List all themes"
    puts "5. Add new recommendation"
    puts "6. List all unread recommendations"
    puts "7. Logout"
    puts "8. Exit"
    print "> "
  end
  # rubocop:enable Metrics/MethodLength

  def print_subscriber_menu
    puts "--------------------"
    puts "------- MENU -------"
    puts "--------------------"
    puts "1. List my unread recommendations"
    puts "2. Mark recommendation as read"
    puts "3. Logout"
    puts "4. Exit"
    print "> "
  end

  # rubocop:disable Metrics/MethodLength
  def recommender_action(choice)
    case choice
    when 1 then @books_controller.add
    when 2 then @books_controller.list
    when 3 then @themes_controller.add
    when 4 then @themes_controller.list
    when 5 then @recommendations_controller.add
    when 6 then @recommendations_controller.list_unread_recommendations
    when 7 then logout!
    when 8 then stop!
    else puts "Try again..."
    end
  end
  # rubocop:enable Metrics/MethodLength

  def subscriber_action(choice)
    case choice
    when 1 then @recommendations_controller.list_my_recommendations(@current_user)
    when 2 then @recommendations_controller.mark_as_read(@current_user)
    when 3 then logout!
    when 4 then stop!
    else puts "Try again..."
    end
  end

  def logout!
    @current_user = nil
  end

  def stop!
    logout!
    @running = false
  end
end
