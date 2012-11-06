#!/bin/bash

find -type d | while read i
do
   cd "$i";
   echo "Current Directory: "$i;
   if [[ ls || grep ape ]]; then
      for j in *.ape
      do
         if [$j != "*" ]; then
            mac "$j" "$j.wav" -d
         else
           echo ape not found in this folder
         fi 
      done
      rename 's/ape.wav/wav' *
      flac *.wav -8 -f --delete-input-file;
      rm *.wav;
      rm *.ape
   fi
   cd -
done
