#!/bin/sh -x

top -n max -o res | awk -vOFS="\t" 'BEGIN{ print "Top Five Processes of WCPU over 0.5\n"} $10>0.5&&NR>8&&NR<15{print $1, $11, $2, $10 }'

# top -n max -o res | sed -n 6,11p | sed -e "s/[[:blank:]]\{1,\}/ /g" -e 's/^[[:space:]]*//g'
# top -n max -o res | sed -n '6,$p' | sed  -e 's/^[[:space:]]*//g' -e 's/[[:blank:]]\{1,\}/\ /g' | cut -f1,11,2,10 -d' '|xargs printf '%s\t%8s\t%s\t%s\n'
# top -n max -o res | sed -n '6,$p' | sed  -e 's/^[[:space:]]*//g' -e 's/[[:blank:]]\{1,\}/\,/g' | cut -f1,11,2,10 -d','|xargs printf '%s\t%8s\t%s\t%s\n'
# top -n max -o res | sed -n '7,$p' | sed  -e 's/^[[:space:]]*//g' -e 's/[[:blank:]]\{1,\}/\,/g' | sort -k 3
# top -n max -o res | awk -vOFS="\t" 'BEGIN{ print "Top Five Processes of WCPU over 0.5\n"} $10>0.5&&NR>8&&NR<15{print $1, $11, $2, $10 }' | sort -k2,4n