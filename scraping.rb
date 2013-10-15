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
    :AWS_secret_key => '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'
}

#
# Amazon APIからASINを取得
#
def getAsin(title)
    res = Amazon::Ecs.item_search(title, {
        #:title => title,
        :search_index => 'DVD',
        :responce_group => 'Small',
        :country => 'jp'}
    )

    if res.items.length > 0
        asinCode = res.items.first.get('ASIN')
    else
        asinCode = nil
    end

    sleep 0.1

    return asinCode
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
                	file.write title
                 	break
                end
                file.write title + "\n"
                titlesNum += 1
            end
        end
    }
end

def genCode(genedFile, fileName)
    File.open(genedFile, 'w:UTF-8') { |file|
        File.foreach(fileName){ |line|
            title = line.chomp

            asinCode = getAsin(title)

            if asinCode != nil
                file.write '<div class="col-sm-6 col-md-4">
                                <div class="thumbnail">
                                    <a href="http://www.amazon.co.jp/gp/product/' + asinCode + '/ref=as_li_tf_il?ie=UTF8&camp=247&creative=1211&creativeASIN' + asinCode + '&linkCode=as2&tag=cigeek-22"><img alt="300x200" src="http://ws-fe.amazon-adsystem.com/widgets/q?_encoding=UTF8&ASIN=' + asinCode + '&Format=_SL300_&ID=AsinImage&MarketPlace=JP&ServiceVersion=20070822&WS=1&tag=cigeek-22"></a>
                                    <div class="caption">
                                    <h3><a href="http://www.amazon.co.jp/gp/product/' + asinCode + '/ref=as_li_tf_il?ie=UTF8&camp=247&creative=1211&creativeASIN=' + asinCode + '&linkCode=as2&tag=cigeek-22">' + title + '</a></h3>
                                    </div>
                                </div>
                            </div>'
            end
        }
    }
end

# 洋画のタイトルを取得
scrapeTitles("http://posren.livedoor.com/static/corner/old_now.html?id=1", "foreignTitles.dat")
genCode("foreign.dat", "foreignTitles.dat")

# 邦画のタイトルを取得
scrapeTitles("http://posren.livedoor.com/static/corner/old_now.html?id=3", "japaneseTitles.dat")
genCode("japanese.dat", "japaneseTitles.dat")