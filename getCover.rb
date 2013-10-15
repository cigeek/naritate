require 'amazon/ecs'

# AWS接続設定
Amazon::Ecs.options = {
	:associate_tag => 'cigeek-22',
	:AWS_access_key_id => 'AKIAJA6MN3AC3L2XZQJQ',
	:AWS_secret_key => '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',
}

def getInfo(title)
	res = Amazon::Ecs.item_search(title, {
		#:title => title,
		:search_index => 'DVD',
		:responce_group => 'ItemAttributes',
		:country => 'jp'}
	)

	p res.items.first.get('Fotmat')

	if res.items.length > 0 
		asinCode = res.items.first.get('ASIN')
	end

	return asinCode

end

#title = "40男のバージンロード"
#puts getInfo(title).marshal_dump
p getInfo("びちゃびちゃWパイパン潮吹き")