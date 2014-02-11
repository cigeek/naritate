class AddBoosTable < ActiveRecord::Migration
  def change
    add_column :foreigntitles, :boos, :integer, default: 0
    add_column :japanesetitles, :boos, :integer, default: 0
  end
end
