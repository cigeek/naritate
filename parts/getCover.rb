require 'amazon/ecs'

# AWS接続設定
Amazon::Ecs.options = {
	:associate_tag => 'cigeek-22',
	:AWS_access_key_id => 'AKIAJA6MN3AC3L2XZQJQ',
	:AWS_secret_key => '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',
}

def getInfo(title)
	res = Amazon::Ecs.item_search('', {
		:title => title,
		:search_index => 'DVD',
		:responce_group => 'Small',
		:country => 'jp'}
	)

	if res.items.length > 0
		asinCode = res.items.first.get('ASIN')
	end

	return asinCode
end

#title = "40男のバージンロード"
#puts getInfo(title).marshal_dump
puts getInfo("40男のバージンロード")

=begin
def addInfo(fileName)
File.open(fileName, 'r:UTF-8') { |file|
		puts file

		#asinCode = getInfo(title);
		#file.write asinCode + ", " + title
	}
end

addInfo("foreignTitles.dat")
=end