#!/bin/bash

for i in * ; do
	cd "$i"
	jhead -nf%Y%m%d-%H%M%S *.jpg
	cd ..
done
