class Bookworm
  attr_accessor :id
  attr_reader :username, :password, :role

  def initialize(attrs = {})
    @id = attrs[:id]
    @username = attrs[:username]
    @password = attrs[:password]
    @role = attrs[:role]
  end

  def recommender?
    @role == "recommender"
  end

  def subscriber?
    @role == "subscriber"
  end
end
