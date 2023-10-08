require_relative '../views/session_view'

class SessionsController
  def initialize(bookworm_repository)
    @session_view = SessionView.new
    @bookworm_repository = bookworm_repository
  end

  def login
    username = @session_view.ask_for(:username)
    user = @bookworm_repository.find_by_username(username)
    password = @session_view.ask_for(:password)
    if user && user.password == password
      @session_view.welcome(username)
      return user
    else
      @session_view.wrong_credentials
      login
    end
  end
end
