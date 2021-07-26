#!/bin/sh -x

top -n max -o res | awk -vOFS="\t" 'BEGIN{print "Top Five Processes of RES\n"} NR>8&&NR<14 {print $1, $11, $2, $7 }'