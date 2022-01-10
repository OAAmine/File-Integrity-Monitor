#!/bin/bash




#Must run script as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

#create logs file if it doesn't exit 
if [ ! -f ".logs.txt" ]; then
	touch .logs.txt
fi


#some decoration (figlet has to be installed on your system)
figlet A basic FIM
NC='\033[0m' # No Color
RED='\033[0;31m'
BLUE='\033[0;34m'
ORANGE='\033[0;33m'

#User input 
echo -ne "would you like to\n	1) Create a new .baseline\nOr\n	2) Proceed with the previously recorded one\n1 | 2 ? "
read ans
 

#function that calculates the filehash for the specified file directory in function call argument 
function calculate_file_hash(){
	filehash=$(sha256sum $1 | cut -d ' ' -f 1)
	filepath=$1
	path_and_hash=$filepath"|"$filehash
	echo $path_and_hash
}

#verify if input is either 1 or 2 ----------------------------------------------





#--------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------------#
#--------------------------------------- Create new .baseline -------------------------------------------
if [ "$ans" = "1" ];then
	echo "Creating new .baseline"
	#calculate hash from the target files and store them in a .baseline.txt file 
	monitoring_dir=$(pwd)
	
	#delete .baseline file if already exists
	if [ -f ".baseline.txt" ]; then
		echo -e ".baseline already exists !\ndeleting old .baseline...\ncreating new .baseline..."
		rm .baseline.txt
		>.baseline.txt
	fi
	
	
	#filling in the .baseline.txt file with filepath|filehash pairs
	for entry in "$monitoring_dir"/*
	do
		res=$(calculate_file_hash "$entry")
		echo $res >> .baseline.txt
	done
	sudo chmod 777 .baseline.txt 
	echo ".baseline created"
	



#--------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------------# 
#------------------------------------ Proceed with the previously recorded .baseline ----------------------------
else
	declare -A path_hash_dict
	Lines=$(cat .baseline.txt)
	monitoring_dir=$(pwd)
	#creating a dictionary with filepath as key and filehash as value
	lines=$(cat .baseline.txt)
	echo -e "Start...\nMonitoring Files...\nYou will be notified of any changes here\nFor more details about changes made, see logs.txt file\nPress [CTRL+C] to stop monitoring."
	for line in $lines 
	do
		path=$( echo "$line" | cut -d '|' -f1 )
		hash=$( echo "$line" | cut -d '|' -f2-)
		path_hash_dict[$path]=$hash
	done 
	while true
	do
		last_event=$(date)
		sleep 1
		
		#checking if a file has been deleted 
		for key in "${!path_hash_dict[@]}"; do
			if [ ! -f "$key" ]; then
				echo -e "${RED}WARNING :${NC} a file has been ${ORANGE}REMOVED ! ${NC}\n${BLUE}FILE NAME :${NC} $key"
			fi
		done


		for file in "$monitoring_dir"/*
		do
			hash=$(sha256sum $file | cut -d ' ' -f 1)
			if [ ! -v path_hash_dict[$file] ]; then
				echo -e "${RED}WARNING :${NC} a file has been ${ORANGE}CREATED ! ${NC}\n${BLUE}FILE NAME :${NC} $key"
				$last_event= echo "$(date)"
			else
				if [ "$hash" = "${path_hash_dict[$file]}" ]; then
				   continue
				elif [ "$hash" != "${path_hash_dict[$file]}" ] && [[ $last_event != $(date) ]]; then
					echo -e "${RED}WARNING :${NC} a file has been ${ORANGE}CHANGED ! ${NC}\n${BLUE}FILE NAME :${NC} $key"
				fi
			fi
		done

	done
	
fi

