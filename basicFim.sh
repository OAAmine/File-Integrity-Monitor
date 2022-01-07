#!/bin/bash
echo -ne "would you like to\n	1) Create a new baseline\nOr\n	2) Proceed with the previously recorded one\n1 | 2 ? "
read ans
echo "Creating new baseline"
 
function calculate_file_hash(){
	filehash=$(sha256sum $1 | cut -d ' ' -f 1)
	filepath=$1
	x=$filepath"|"$filehash  
	#echo $x
	echo $x >> baseline.txt
}


#verify if input is either 1 or 2 ----------------------------------------------
if [ "$ans" = "1" ];then
#calculate hash from the target files and store them in a baseline.txt file 
	monitoring_dir=$(pwd)
	#delete baseline file if already exists
	if [ -f "baseline.txt" ]; then
		echo "exists"
		rm baseline.txt
		>baseline.txt
	fi
	for entry in "$monitoring_dir"/*
	do
		calculate_file_hash "$entry"
	done
	echo "Baseline created"

	#collect all files in the target 
	declare -A test_var
	cat baseline.txt | while read line 
	do
		path=$( echo "$line" | cut -d '|' -f1 )
		hash=$( echo "$line" | cut -d '|' -f2-)
		test_var[$path]=$hash
	done
	# echo "${test_var[/home/oaamine/Projects/file_integrity_monitor/basicFim.sh]}"


	for entry in "$monitoring_dir"/*
	do
		hash = sha256sum $entry
		if [ ! -v test_var[$entry] ]; then
    	echo "key2 does not exists in a dictionary"
		fi
	done

else


	
 	echo "no"
fi

