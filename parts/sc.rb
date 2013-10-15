# -- Coding: UTF-8

# ライブラリの読み込み
require 'open-uri'
require 'rubygems'
require 'nokogiri'
require 'amazon/ecs'

# 取得する件数
MAX_TITLES = 12

# Amazon API接続設定
Amazon::Ecs.options = {
    :associate_tag => 'cigeek-22',
    :AWS_access_key_id => 'AKIAJA6MN3AC3L2XZQJQ',
    :AWS_secret_key => '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',
}

#
# Amazon APIからASINを取得
#
def getAsin(title)
    res = Amazon::Ecs.item_search('', {
        :title => title,
        :search_index => 'DVD',
        :responce_group => 'Small',
        :country => 'jp'}
    )

    if res.items.length > 0
        return res.items.first.get('ASIN')
    end
end

#
# 映画タイトルのスクレイピング
#
def scrapeTitles(targetURL, fileName)

    charset = nil
    html = open(targetURL) do |f|
        charset = f.charset
        f.read
    end
    doc = Nokogiri::HTML.parse(html, nil, charset)

    # 映画のタイトルを抽出してファイルに書き込み
    titlesNum = 1
    File.open(fileName, 'w:UTF-8') { |file|
        doc.xpath('//div[@class="productBox"]').each do |node|
            title = node.xpath('span[@class="productText"]/a').text
            if title !~ /Blu\-ray/
                if titlesNum >= MAX_TITLES then
                	file.write getAsin(title) + "," + title
                 	break
                end
                file.write getAsin(title) + "," + title + "\n"
                titlesNum += 1
            end
        end
    }
end

# 洋画のタイトルを取得
#scrapeTitles("http://posren.livedoor.com/static/corner/old_now.html?id=1", "foreignTitles.dat")
# 邦画のタイトルを取得
#scrapeTitles("http://posren.livedoor.com/static/corner/old_now.html?id=3", "japaneseTitles.dat")
# アニメのタイトルを取得
scrapeTitles("http://posren.livedoor.com/static/corner/old_now.html?id=83", "animeTitles.dat")