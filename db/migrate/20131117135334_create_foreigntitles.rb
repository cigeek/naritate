class CreateForeigntitles < ActiveRecord::Migration
  def up
    create_table :foreigntitles do |t|
      t.string :title, :null => false
      t.string :asin, :null => false
      t.integer :favs, :default => 0
      t.integer :times, :default => 0
      t.timestamps
    end
  end

  def down
    drop_table :foreigntitles
  end
end
