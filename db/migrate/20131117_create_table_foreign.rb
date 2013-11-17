class CreateForeigntitles < ActiveRecord::Migration
  def up
    create_table(:Foreigntitles, :id => false) do |t|
      t.string :id
      t.string :title
      t.integer :favs, :default => 0
      t.integer :times, :default => 0
      t.timestamps :added
    end

    add_index :Foreigntitles, [:id, :title], :unique => true
  end

  def down
    drop_table :Foreigntitles
  end
end