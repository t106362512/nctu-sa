#!/bin/bash -x

trap "_tr" SIGINT

function _tr {
	echo "Ctrl + c"
	exit 1
}

function logingrank {
	lr=$(last|sed '$d'|awk '{if(!($2~/time/)&&$2){k[$1]++}}END{for (row in k) print row,k[row]}'| sort -t " " -rnk 2| cat -n)
	dialog --title "Login Rank" --msgbox "${lr}" 20 60
}

function portinfo {
	while true
	do
		ns=$(sockstat -4|awk -vS="\t" 'NR>1 {print $3" "$5"_"$6}')
		pid=$(dialog --stdout --title "Port INFO(PID and Port)" --menu "" 40 70 40 ${ns})
		if [[ $? -eq 1 ]]; then
            return 1
        fi
        dialog --title "Process State: ${pid}" --msgbox "$(ps -o user,pid,ppid,stat,%cpu,%mem,command ${pid}|rs -T|column -t)" 10 60
	done
}

function mountpointinfo {
	while true
	do
		mi=$(df|awk -vS="\t" 'NR>1{print $1, $6}')
		mid=$(dialog --stdout --title "MOUNTPOINT INFO" --menu "" 40 70 40 ${mi})
		if [[ $? -eq 1 ]]; then
            return 1
        fi
        dialog --title "${mid}" --msgbox "$(df -h ${mid} |rs -T|column -t)" 20 60
	done
}

function savesysinfo {
    path=$(dialog --title "Load from file" --stdout --inputbox "Enter the path:" 10 50 "")
	if ! [[ ${path} == /* || ${path} =~ "~" ]]; then
		path="${HOME}/${path}"
	fi
    prefix="This system report is generated on $(date) \n==="
    report="${prefix}\n$(sysctl -h kern.hostname kern.ostype kern.osrelease hw.machine hw.model hw.ncpu hw.physmem)"
	echo -e "${report}" > ${path}
	result=$(echo -e "${report}\nThe output file is save to ${path}") # Forrmater
	dialog --title "System Info" --msgbox "${result}" 40 80
}

function loadsysinfo {
    path=$(dialog --title "Save to file" --stdout --inputbox "Enter the path:" 10 50 "")
	if ! [[ ${path} == /* || ${path} =~ "~" ]]; then
		path="${HOME}/${path}"
	fi
	result=$(cat "${path}")
	dialog --title "System Info" --msgbox "${result}" 40 80
}

while true
do
    selection=$(dialog  --stdout --cancel-label "Exit" --menu "System Info Panel" 20 30 10 \
        1 "LOGING RANK" \
        2 "PORT INFO" \
        3 "MOUNTPOINT INFO" \
        4 "SAVE SYSTEM INFO" \
        5 "LOAD SYSTEM INFO")

	result=$?
	if [[ $result -eq 1 ]]; then
		echo "Cancle"
		exit 0
	elif [[ $result -eq 255 ]]; then
		echo "ESC"
		exit 2
	fi

	case $selection in
		1) logingrank;;
		2) portinfo;;
		3) mountpointinfo;;
		4) savesysinfo;;
		5) loadsysinfo;;
		# *) dialog --msgbox "Sorry,invalid selection" 10 30
	esac
done