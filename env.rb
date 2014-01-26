#== データベース環境設定 ==#
# データベース接続
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'sqlite3://localhost/dev.db')

# テーブルをクラス化
class Foreigntitle < ActiveRecord::Base
end
class Japanesetitle < ActiveRecord::Base
end

#== 定数 ==#
# 一覧表示するレコードの件数
MAX_TITLES = 18

# ランキング表示するレコードの件数
MAX_RANK = 5