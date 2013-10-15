def genCode(genedFile, fileName)
	File.open(genedFile, 'w:UTF-8') { |file|
		File.foreach(fileName){ |line|
			info = line.chomp.split(",")

			file.write '<div class="col-sm-6 col-md-4">
							<div class="thumbnail">
								<a href="http://www.amazon.co.jp/gp/product/' + info[0] + '/ref=as_li_tf_il?ie=UTF8&camp=247&creative=1211&creativeASIN' + info[0] + '&linkCode=as2&tag=cigeek-22"><img alt="300x200" src="http://ws-fe.amazon-adsystem.com/widgets/q?_encoding=UTF8&ASIN=' + info[0] + '&Format=_SL300_&ID=AsinImage&MarketPlace=JP&ServiceVersion=20070822&WS=1&tag=cigeek-22"></a>
								<div class="caption">
								<h3><a href="http://www.amazon.co.jp/gp/product/' + info[0] + '/ref=as_li_tf_il?ie=UTF8&camp=247&creative=1211&creativeASIN=' + info[0] + '&linkCode=as2&tag=cigeek-22">' + info[1] + '</a></h3>
								</div>
							</div>
						</div>'
		}
	}
end

genCode("foreign.dat", "foreignTitles.dat")
genCode("japanese.dat", "japaneseTitles.dat")
genCode("anime.dat", "animeTitles.dat")