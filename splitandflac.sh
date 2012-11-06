#!/bin/bash

INFILE="CDImage.ape"
CUEFILE="CDImage.cue"

WAVFILE=$(echo $INFILE|sed 's/.[aA][pP][eE]$//').wav
TITLES=$(cueprint -t %n.%t= $CUEFILE)

#convert to wav (shnsplit not always cat split .ape)
mac $INFILE $WAVFILE -d

#split wav file
cuebreakpoints $CUEFILE | shnsplit $WAVFILE

#rm big wave file
rm $WAVFILE

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
   #mv split-track$zz$i.wav $z$waves.wav
   mv split-track$z$i.wav $z$waves.wav
   ((i++))
done

#flac all .waves
flac *.wav -8

#clean up
rm *wav
