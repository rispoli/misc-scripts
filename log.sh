#!/bin/bash

log_file=`date +%Y.%m.%d`

echo -e "\n[`date +%H.%M.%S`]\n" >> $log_file

vim + $log_file
