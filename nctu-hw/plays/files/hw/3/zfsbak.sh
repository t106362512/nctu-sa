#!/usr/local/bin/bash

# 
# Helper function
# 
zfsf_list_snapshot_by_creation(){
	zfs list -rt snapshot -o name -s creation ${1} | sed 1d
}

zfsf_table_snapshot_with_id(){
	table=$(zfsf_list_snapshot_by_creation ${1} | awk 'BEGIN{printf("ID\tDATASET\t\tTIME\n")} {split($0, a, "@"); printf("%s\t%s\t%s\n", NR, a[1], a[2])}')
	[[ ! -z "${2##*[!0-9]*}" ]] && echo "${table}" | sed -n "1p; $(( ${2} > 1 ? ${2}+1 : 2 ))p" || echo "${table}"
}

zfsf_datetime() {
	[[ ! -z "${1}" ]] && date "+${1}" || date '+%Y-%m-%d-%H:%M:%S'
}


#
# ZFS backup function
#
zfsb_usage(){
    p_name=$(basename $0)
    cat <<EOF
Usage:
- create: ${p_name} DATASET [ROTATION_CNT]
- list: ${p_name} -l|--list [DATASET|ID|DATASET ID]
- delete: ${p_name} -d|--delete [DATASET|ID|DATASET ID]
- export: ${p_name} -e|--export DATASET [ID]
- import: ${p_name} -i|--import FILENAME DATASET
EOF
    exit 0
}

zfsb_create(){
	data_set=$1
	datetime=$(zfsf_datetime)
	[[ -z ${2##*[!0-9]*} ]] && rotate_counter="20" || rotate_counter=$2
	zfs snapshot -r "${data_set}@${datetime}" && echo "Snap ${data_set}@${datetime}"
	snapshot_counter=$(zfsf_list_snapshot_by_creation ${data_set} | wc -l | tr -d ' ')
	clear_counter=$(( ${snapshot_counter}-${rotate_counter} ))
	[[ ${clear_counter} > 0 ]] && zfsf_list_snapshot_by_creation ${data_set} | head "-n${clear_counter}" | xargs -I sshot sh -c 'zfs destroy sshot && echo Destroy sshot'
}

zfsb_list() {
	if [[ ${#} == 1 ]]; then
		echo "$(zfsf_table_snapshot_with_id)"
	elif [[ ${#} == 2 ]]; then
		[[ ! -z "${2##*[!0-9]*}" ]] && echo "$(zfsf_table_snapshot_with_id "" ${2})" || echo "$(zfsf_table_snapshot_with_id ${2})"
	elif [[ ${#} == 3 && ! -z "${3##*[!0-9]*}" ]]; then
        echo "$(zfsf_table_snapshot_with_id ${2} ${3})"
	else
		printf 'Bad input!\n' >&2; exit 1
	fi
}

zfsb_delete(){
	zfsb_list ${@} | sed 1d | awk -vOFS='\t' '{printf("%s@%s\n", $2, $3)}' | xargs -I sshot sh -c 'zfs destroy sshot && echo Destroy sshot'
}

zfsb_export(){
	if [[ ${#} > 1 && ${#} < 4 && ! -z ${2} ]]; then
		[[ ! -z "${3##*[!0-9]*}" ]] && id=$3 || id="1"
		snapshot=$(zfsf_table_snapshot_with_id ${2} ${id} | sed 1d | awk -vOFS="\t" '{printf("%s@%s\n", $2, $3)}')
		snapshot_export_path=~/${snapshot}.gz.enc
		[[ ! -z ${snapshot} ]] && mkdir -p "$(dirname ${snapshot_export_path})" && zfs send ${snapshot} | gzip | openssl enc -e -aes256 -pbkdf2 -out ${snapshot_export_path} && echo "Export ${snapshot} to ${snapshot_export_path}"
	else
		printf 'Bad input!\n' >&2; exit 1
	fi
}

zfsb_import(){
	if [[ ${#} > 1 && ${#} < 4 && ! -z ${2} && ! -z ${3} ]]; then
		file_path="${2}"
		data_set="${3}@$(zfsf_datetime)"
		openssl enc -d -aes256 -pbkdf2 -in ${file_path} | gunzip | zfs recv -F ${data_set} && echo "${file_path}" to "${3}"
	else
		printf 'Bad input!\n' >&2; exit 1
	fi
}

main() {
	set -e
    if [[ -z ${1} ]]; then
        zfsb_usage;
    elif [[ ${1} == "-l" || ${1} == "--list" ]]; then
        zfsb_list "${@}";
    elif [[ ${1} == "-d" || ${1} == "--delete" ]]; then
        zfsb_delete "${@}";
    elif [[ ${1} == "-e" || ${1} == "--export" ]]; then
        zfsb_export "${@}";
    elif [[ ${1} == "-i" || ${1} == "--import" ]]; then
        zfsb_import "${@}";
    elif [[ ${#} > 0 && ${#} <3 ]]; then
        zfsb_create "${@}";
	else
		printf 'Bad input!\n' >&2; exit 1
    fi
}

main "${@}"
