#!/bin/bash

# http://blog.windfluechter.net/archives/405-Converting-RAWNEF-images-to-JPEG.html
# http://u88.n24.queensu.ca/exiftool/forum/index.php/topic,2705.0.html

dcraw -w -b 1.2 -q 3 -T *.NEF

for i in *.tiff
do
	convert "${i}" "${i%%.tiff}.jpg"
	exiftool -tagsfromfile "${i}" "${i%%.tiff}.jpg"
done

rm *_original
