require_relative '../views/theme_view'
require_relative '../models/theme'

class ThemesController
  def initialize(theme_repository)
    @theme_repository = theme_repository
    @theme_view = ThemeView.new
  end

  
end
