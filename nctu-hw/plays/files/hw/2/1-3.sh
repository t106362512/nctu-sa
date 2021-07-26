#!/bin/bash -x

# top -n max -o res | tee >(awk -vOFS="\t" 'BEGIN{ print "Top Five Processes of WCPU over 0.5\n"} $10>0.5&&NR>8&&NR<15{print $1, $11, $2, $10 }') >(awk -vOFS="\t" 'BEGIN{ print "Top Five Processes of WCPU over 0.5\n"} $10>0.5&&NR>8&&NR<15{print $1, $11, $2, $10 }') | tee >(awk -vOFS="\t" 'BEGIN{print "Top Five Processes of RES\n"} NR>8&&NR<14 {print $1, $11, $2, $7 }')
# top -n max -o res | awk -vOFS="\t" 'BEGIN {print "Bad Users:\n"} $2&&NR>9 {key=$2; count[key]++}  END {for ( key in count ) { print (key=="root"?"\033[32m"key"\033[0m ":count[key]>=2?"\033[31m"key"\033[0m ":"\033[33m"key"\033[0m ") } }'
# top -n max -o res | tee >(awk -vOFS="\t" 'BEGIN{ print "Top Five Processes of WCPU over 0.5\n"} $10>0.5&&NR>8&&NR<15{print $1, $11, $2, $10 }') >(awk -vOFS="\t" 'BEGIN{print "\nTop Five Processes of RES\n"} NR>8&&NR<14 {print $1, $11, $2, $7 }')

top -n max -o res | tee >(awk -vOFS="\t" 'BEGIN{ print "Top Five Processes of WCPU over 0.5\n"} $10>0.5&&NR>8&&NR<15{print $1, $11, $2, $10 }') >(awk -vOFS="\t" 'BEGIN{print "\nTop Five Processes of RES\n"} NR>8&&NR<14 {print $1, $11, $2, $7 }') >(awk -vOFS="\t" 'BEGIN {print "\nBad Users:\n"} $2&&NR>9 {key=$2; count[key]++}  END {for ( key in count ) { print (key=="root"?"\033[32m"key"\033[0m ":count[key]>=2?"\033[31m"key"\033[0m ":"\033[33m"key"\033[0m ") } }') | awk '/Top Five Processes of WCPU over 0.5/{p=1}p'
