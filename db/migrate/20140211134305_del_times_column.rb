class DelTimesColumn < ActiveRecord::Migration
  def change
    remove_column :foreigntitles, :times
    remove_column :japanesetitles, :times
  end
end
