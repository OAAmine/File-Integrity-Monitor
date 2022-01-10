import os
import hashlib


#Must run script as root
if os.geteuid() != 0:
    print("Please run as root")
    exit

#User input 
ans=input("would you like to\n	1) Create a new .baseline\nOr\n	2) Proceed with the previously recorded one\n1 | 2 ? ")


#function that calculates the filehash for the specified file directory in function call argument 
def calculate_file_hash(filepath):
	filehash = hashlib.sha256(filepath).hexdigest()
	return filehash+"|"+filepath


#--------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------------#
#--------------------------------------- Create new .baseline -------------------------------------------
if (ans == 1):
	print("Creating new baseline")

	#calculate hash from the target files and store them in a .baseline.txt file 
	monitoring_dir=os.getcwd()




    	#delete .baseline file if already exists
	if os.path.isfile('.baseline.txt') == True :
		print(".baseline already exists !\ndeleting old .baseline...\ncreating new .baseline...")


