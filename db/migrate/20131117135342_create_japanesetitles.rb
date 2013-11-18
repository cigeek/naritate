class CreateJapanesetitles < ActiveRecord::Migration
  def up
    create_table :japanesetitles do |t|
      t.string :title
      t.string :asin
      t.integer :favs, :default => 0
      t.integer :times, :default => 0
      t.timestamps
    end
  end

  def down
    drop_table :japanesetitles
  end
end
