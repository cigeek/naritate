class CreateIndexJapanese < ActiveRecord::Migration
  def change
    add_index :japanesetitles, [:title, :asin], :unique => true
  end
end
