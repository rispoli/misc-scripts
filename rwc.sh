#!/bin/bash

Wallpapers=$HOME/Wallpapers

LowerBound=1
RandomMax=32767
UpperBound=`ls $Wallpapers | wc -l`
CurrentWall=$(( $LowerBound + ($UpperBound * $RANDOM) / ($RandomMax + 1) ))

File=`ls $Wallpapers | head -$CurrentWall | tail -1`
feh --bg-scale $Wallpapers/$File
