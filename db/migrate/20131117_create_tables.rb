class CreateForeigntitles < ActiveRecord::Migration
  def up
    create_table :Foreigntitles do |t|
      t.string :id, unique, primary key
      t.string :title, unique
      t.integer :favs, default 0
      t.integer :times, default 0
      t.timestamps :added, default current_timestamp
    end
  end

  def down
    drop_table :Foreigntitles
  end
end

class CreateJapanesetitles < ActiveRecord::Migration
  def up
    create_table :Japanesetitles do |t|
      t.string :id, unique
      t.string :title, unique
      t.integer :favs, default 0
      t.integer :times, default 0
      t.timestamps :added, default current_timestamp
    end
  end

  def down
    drop_table :Japanesetitles
  end
end