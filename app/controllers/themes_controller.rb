require_relative '../views/theme_view'
require_relative '../models/theme'

class ThemesController
  def initialize(theme_repository)
    @theme_repository = theme_repository
    @theme_view = ThemeView.new
  end

  def add
    new_theme = @theme_view.add
    theme = Theme.new(new_theme)
    @theme_repository.create(theme)
  end

  def list
    themes = @theme_repository.all
    @theme_view.display_list(themes)
  end

  def edit
    list
    selection_index = @theme_view.edit_choice
    updated_values = @theme_view.make_edit
    @theme_repository.all[selection_index].name = updated_values[0]
    @theme_repository.all[selection_index].description = updated_values[1]
  end

  def remove
    list
    @theme_repository.destroy(@theme_view.remove)
  end
end
