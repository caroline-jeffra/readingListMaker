require_relative '../views/session_view'
require_relative '../models/bookworm'

class SessionsController
  def initialize(bookworm_repository)
    @bookworm_repository = bookworm_repository
    @session_view = SessionView.new
  end

  def login
    username = @session_view.ask_for("username")
    user = @bookworm_repository.find_by_username(username)
    password = @session_view.ask_for("password")
    if user && user.password == password
      @session_view.welcome(username)
      return user
    else
      login
    end
  end
end
