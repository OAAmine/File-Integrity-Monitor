#!/bin/bash
figlet A basic FIM
#User input 
echo -ne "would you like to\n	1) Create a new baseline\nOr\n	2) Proceed with the previously recorded one\n1 | 2 ? "
read ans
 

#function that calculates the filehash for the specified file directory in function call argument 
function calculate_file_hash(){
	filehash=$(sha256sum $1 | cut -d ' ' -f 1)
	filepath=$1
	echo $filepath"|"$filehash  
	echo $x >> baseline.txt
}
#store filepath - filehash in a key-value dictionnary


#verify if input is either 1 or 2 ----------------------------------------------





#--------------------------------------- Create new baseline -------------------------------------------
if [ "$ans" = "1" ];then
	echo "Creating new baseline"

#calculate hash from the target files and store them in a baseline.txt file 
	monitoring_dir=$(pwd)
	#delete baseline file if already exists
	if [ -f "baseline.txt" ]; then
		echo -e "baseline already exists !\ndeleting old baseline...\ncreating new baseline..."
		rm baseline.txt
		>baseline.txt
	fi
	for entry in "$monitoring_dir"/*
	do
		calculate_file_hash "$entry"
	done
	echo "Baseline created"
	
	declare -A path_hash_dict
	cat baseline.txt | while read line 
	do
		path=$( echo "$line" | cut -d '|' -f1 )
		hash=$( echo "$line" | cut -d '|' -f2-)
		path_hash_dict[$path]=$hash
	done
	
	for key in "${!path_hash_dict[@]}"; do
		if [ ! -f "$key" ]; then
			echo -e "A file has been removed !\n file name : $key"
			# echo "$key ${path_and_hash[$key]}"
		fi
	done
	# for entry in "$monitoring_dir"/*
	# do
	# 	#hash=sha256sum $entry
	# 	if [ ! -v path_hash_dict[$entry] ]; then
    # 	echo -e "A new file has been found !\n ${ls -l $entry}"
	# 	fi
	# done



#------------------------------------ Proceed with the previously recorded baseline ----------------------------
else
	declare -A path_hash_dict
	Lines=$(cat baseline.txt)
	# echo "$Lines" 
	for line in $Lines 
	do
		path=$( echo "$line" | cut -d '|' -f1 )
		hash=$( echo "$line" | cut -d '|' -f2-)
		path_hash_dict[$path]=$hash
	done
	#check if a file has been removed 
	for key in "${!path_hash_dict[@]}"; do
		if [ ! -f "$key" ]; then
			echo -e "A file has been removed !\n file name : $key"
		fi
	done




fi

