File.foreach("foreignTitles.dat"){ |line|
    #tmp = line.chomp
    info = line.chomp.split(",")
    p info[0]

    break
}
