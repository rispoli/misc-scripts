# http://ruby-mp3info.rubyforge.org/

require "rubygems"
require "mp3info"

# Usage:
# find . -type f -name *.mp3 | sort > filename
# ruby ~/scripts/mp3.rb filename

hash = Hash.new

f = File.open($*[0], "r")
lines = f.readlines
lines.each do |file|
	#puts "'" + file.to_s.strip + "'"
	Mp3Info.open(file.to_s.strip) do |mp3|

		t_b = hash[mp3.tag2.TALB] ? hash[mp3.tag2.TALB]["total_bitrate"] : 0
		n = hash[mp3.tag2.TALB] ? hash[mp3.tag2.TALB]["n"] : 0
		vbr = hash[mp3.tag2.TALB] ? hash[mp3.tag2.TALB]["vbr"] : true

		hash[mp3.tag2.TALB] = {"artist" => mp3.tag2.TPE1, "year" => mp3.tag2.TDRC, "total_bitrate" => mp3.bitrate + t_b, "n" => n + 1, "vbr" => vbr && mp3.vbr}

	end
end

hash.each {|album, d| puts d["artist"] + " | " + album + " | " + d["year"] + " | " + (d["total_bitrate"] / d["n"]).to_s + (d["vbr"] ? "VBR" : "CBR") }
