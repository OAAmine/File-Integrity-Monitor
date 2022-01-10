import os 
import hashlib

#must run script as root 
if os.getuid() != 0:
    print("Please run as root")
    exit

def calculate_file_hash(filepath):
    filename = str(monitoring_dir + filepath)
    sha256_hash = hashlib.sha256()
    with open(filename,"rb") as f:
    # Read and update hash string value in blocks of 4K
        for byte_block in iter(lambda: f.read(4096),b""):
            sha256_hash.update(byte_block)
        return(filepath+"|"+sha256_hash.hexdigest()+"\n")
        







#use input 
ans = input ("Would you like to\n   1)Create a new baseline\nOr\n   2) Proceed with the previously recorded baseline")

if ans == '1' : 
    print ("Creating new baseline")

    #target directory
    monitoring_dir = "/home/oaamine/Projects/file_integrity_monitor/testing_files/"     #os.getcwd()


    #delete baseline file if it already exists
    if os.path.isfile(monitoring_dir + '.baseline.txt') == True : 
        print("\n it EXISTS")
        os.remove(monitoring_dir + '.baseline.txt')
        f = open(monitoring_dir + '.baseline.txt','+w')
    else :
        f = open(monitoring_dir + '.baseline.txt','+w')


    #filling in the baseline file with filepath|filehash pairs
    files = [f for f in os.listdir(monitoring_dir) if os.path.isfile(os.path.join(monitoring_dir, f))]   
    f = open(monitoring_dir + ".baseline.txt","a") 
    for entry in files :
        print(calculate_file_hash(entry))
        f.write(calculate_file_hash(entry))




























else : 
    monitoring_dir = "/home/oaamine/Projects/file_integrity_monitor/testing_files/"     #os.getcwd()

    filepath_filehash_dict = {}
# Strips the newline character
    with open(monitoring_dir + ".baseline.txt","r") as a_file:
        for line in a_file:
            stripped_line = line.strip()
            filepath = line.split('|')[0]
            filehash = line.split('|')[1]
            filepath_filehash_dict[filepath] = filehash



    files = filter(os.path.isfile, os.listdir( monitoring_dir ) )  # files only  
    while True :
        

        #chech if a file has been deleted 
        for entry in filepath_filehash_dict :
            if os.path.isfile(monitoring_dir + entry) == False :
                print("file has been DELETED  " + entry)

        for entry in files :
            print(entry)
            hash = calculate_file_hash(entry).split('|')[1]
            if entry not in filepath_filehash_dict:
                print("a new file has been created  " + entry)
                print("the calculated hash " + hash)
                print("the stored hash " + filepath_filehash_dict[entry])
            elif hash != filepath_filehash_dict[entry] : 
                print("file has been changed   " + entry)
        

                
        