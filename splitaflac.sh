#!/bin/bash

INFILE="CDImage.flac"
CUEFILE="CDImage.cue"

TITLES=$(cueprint -t %n.%t= $CUEFILE)

#split flac file
cuebreakpoints $CUEFILE | shnsplit -o flac $INFILE

#change files names
((i=1))
IFS="="

for waves in $TITLES
do
   if (( i < 10 ))
      then zz="00" && z="0"
   fi
   if ((i >= 10 && i < 100 ))
      then zz="0"  && z=""
   fi
   if ((i >= 100 && i < 1000 ))
      then zz=""  && z=""
   fi
   #mv split-track$zz$i.flac $z$waves.flac
   mv split-track$z$i.flac $z$waves.flac
   ((i++))
done
