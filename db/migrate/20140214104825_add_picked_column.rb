class AddPickedColumn < ActiveRecord::Migration
  def change
    add_column :foreigntitles, :picked, :boolean, default: false
    add_column :japanesetitles, :picked, :boolean, default: false
  end
end
