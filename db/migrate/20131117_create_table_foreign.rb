class CreateForeigntitles < ActiveRecord::Migration
  def up
    create_table(:Foreigntitles, :id => false) do |t|
      t.string :id
      t.string :title
      t.integer :favs, :default => 0
      t.integer :times, :default => 0
      t.timestamps :added
    end
  end

  def down
    drop_table :Foreigntitles
  end
end

class CreateJapanesetitles < ActiveRecord::Migration
  def up
    create_table(:Japanesetitles, :id => false) do |t|
      t.string :id
      t.string :title
      t.integer :favs, :default => 0
      t.integer :times, :default => 0
      t.timestamps :added
    end
  end

  def down
    drop_table :Japanesetitles
  end
end