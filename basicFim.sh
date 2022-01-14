#!/bin/bash





#Must run script as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


#if script is called with a directory as argument, monitor the specified directory. If not, monitor the current working dir
if [ $# -eq 0 ]
  then
    monitoring_dir=$(pwd)
	echo "Monitoring directory : $monitoring_dir"
else
	if [[ -d "$1" ]]
	then
		monitoring_dir=$1
		echo "Monitoring directory : $monitoring_dir"
	else
		echo -e "Directory doesn't exist !\nExiting ..."
		exit
	fi
fi




#some decoration (figlet has to be installed on your system)
figlet A basic FIM
NC='\033[0m' # No Color
RED='\033[0;31m'
BLUE='\033[0;34m'
ORANGE='\033[0;33m'


#User input 
echo -ne "would you like to\n	1) Collect a new .baseline\nOr\n	2) Proceed with the previously recorded one\n	[ 1 | 2 ] ? "
read ans



#function that calculates the filehash for the specified file directory in function call argument 
function calculate_file_hash(){
	filehash=$(sha256sum $1 | cut -d ' ' -f 1)
	filepath=$1
	path_and_hash=$filepath"|"$filehash
	echo $path_and_hash
}





#--------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------------#
#--------------------------------------- Create new .baseline -------------------------------------------------#

if [ "$ans" = "1" ];then
	echo "Collecting new .baseline"
	#calculate hash from the target files and store them in a .baseline.txt file 	
	#delete .baseline file if already exists
	if [[ -f ".baseline.txt" ]]; then
		echo -e ".baseline already exists !\ndeleting old .baseline...\ncreating new .baseline..."
		rm .baseline.txt
		>.baseline.txt #hidden file starts with a .
	else
		>.baseline.txt 
	fi
	
	
	#filling in the .baseline.txt file with filepath|filehash pairs
	for entry in "$monitoring_dir"/*
	do
		res=$(calculate_file_hash "$entry")
		echo $res >> .baseline.txt
	done
	sudo chmod 777 .baseline.txt #for testing purposes only, careful who you give r/w permission to
	echo ".baseline collected"
	



#--------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------------# 
#------------------------------------ Proceed with the previously recorded .baseline ----------------------------
else
	declare -A path_hash_dict
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
		sleep 1
		
		#checking if a file has been deleted 
		for key in "${!path_hash_dict[@]}"; do
			if [ ! -f "$key" ]; then
				echo -e "${RED}WARNING :${NC} a file has been ${ORANGE}REMOVED ! ${NC}\n${BLUE}FILE NAME :${NC} $key"
				#ls -la $key #can't execute this command when the file is not there...maybe store all the metadata in a txt file before monitoring 
			fi
		done


		for file in "$monitoring_dir"/*
		do
			hash=$(sha256sum $file | cut -d ' ' -f 1)
			if [ ! -v path_hash_dict[$file] ]; then
				echo -e "${RED}WARNING :${NC} a file has been ${ORANGE}CREATED ! ${NC}\n${BLUE}FILE NAME :${NC} $key"
				ls -la $key
			else
				if [ "$hash" = "${path_hash_dict[$file]}" ]; then
				   continue
				elif [ "$hash" != "${path_hash_dict[$file]}" ]; then
					echo -e "${RED}WARNING :${NC} a file has been ${ORANGE}CHANGED ! ${NC}\n${BLUE}FILE NAME :${NC} $key"
					ls -la $key

				fi
			fi
		done

	done
	
fi

