import os
import hashlib
import sys
import time

#must run script as root
if os.getuid() != 0:
    print("Please run as root")
    exit

if len(sys.argv) == 2:
    if (os.path.isdir(sys.argv[1]) == False):
        print("Directory doesn't exit ! \nExiting...")
        sys.exit()
    else:
        monitoring_dir = sys.argv[1]
elif (len(sys.argv) > 2):
    print("too many arguments ! ")
    sys.exit()
else:
    monitoring_dir = os.getcwd()

print("This is the monitorint directory : " + monitoring_dir)
bl_path= os.path.join(monitoring_dir, '.baseline.txt')#baseline file path


def calculate_file_hash(filepath):
    filename = str(monitoring_dir + "/"+ filepath)
    sha256_hash = hashlib.sha256()
    with open(filename, "rb") as f:
        # Read and update hash string value in blocks of 4K
        for byte_block in iter(lambda: f.read(4096), b""):
            sha256_hash.update(byte_block)
        return (filepath + "|" + sha256_hash.hexdigest() + "\n")


#use input
ans = input(
    "Would you like to\n   1)Create a new baseline\nOr\n   2) Proceed with the previously recorded baseline"
)

if ans == '1':
    print("Creating new baseline")

    #delete baseline file if it already exists
    if os.path.isfile(bl_path) == True:
        print(
            ".baseline already exists !\n deleting old .baseline...\ncreating new .baseline..."
        )
        os.remove(bl_path)
        f = open(bl_path, 'x')
    else:
        f = open(bl_path, "x")

    #filling in the baseline file with filepath|filehash pairs
    files = [
        f for f in os.listdir(monitoring_dir)
        if os.path.isfile(os.path.join(monitoring_dir, f))
    ]
    f = open(bl_path, "a")
    for entry in files:
        f.write(calculate_file_hash(entry))

else:

    filepath_filehash_dict = {}
    # Strips the newline character
    with open(bl_path, "r") as a_file:
        for line in a_file:
            stripped_line = line.strip()
            filepath = line.split('|')[0]
            filehash = line.split('|')[1]
            filepath_filehash_dict[filepath] = filehash

    # files = filter(os.path.isfile, os.listdir(monitoring_dir))  # files only
    # for f in files:
    #     print(str(f))
    
    
    while True:
        time.sleep(1)
        #chech if a file has been deleted
        for entry in filepath_filehash_dict:
            if os.path.isfile(monitoring_dir + entry) == False:
                print("A file has been DELETED  " + entry)
        
        
        
        
        
        for f in os.listdir(monitoring_dir):
            hash = calculate_file_hash(f).split('|')[1]
            #check if a file has been create
            if  (f not in filepath_filehash_dict):
                print("A new file has been CREATED  " + f)

        
        
        
            #check if a file has been Modified
            elif hash != filepath_filehash_dict[f]:
                print("A file has been MODIFIED   " + f)
