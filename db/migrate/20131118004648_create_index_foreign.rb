class CreateIndexForeign < ActiveRecord::Migration
  def change
    add_index :foreigntitles, [:title, :asin], :unique => true
  end
end
