
# A basic FIM
FIM (short for File Integrity Monitor) is a tool that monitors a host’s local system for changes to specified files, directories, and registry settings to detect illicit modifications. In this basic FIM, it accomplishes its task by calculating file hashes and storing them in a baseline, then the monitoring starts by verifying that the current file state hash is equal to the one stored in our trusted baseline.
For a more in-depth step-by-step tutorial, check out this 4 minute read [Documentation](https://dev.to/oaamine/hashing-algorithms-and-creating-a-simple-file-integrity-monitor-fim-5ei9) i made about the project.

This project was heavily inspired by Josh Madakor's [Youtube Video](https://www.youtube.com/watch?v=WJODYmk4ys8&t=156s&ab_channel=JoshMadakor). Check out his channel for cybersecurity related content.
## Installation


### Python


#### on Windows 
- Open your web browser and navigate to the 
[Downloads for Windows section of the official Python website.](https://www.python.org/downloads/windows/)
Search for your desired version of Python. 
- At the time of publishing this article, the latest Python 3 release is version 3.9.6, while the latest Python 2 release is version 2.7.18.
- Select a link to download either the Windows x86-64 executable installer or Windows x86 executable installer
 - Run the Python Installer once downloaded. (In this example, we have downloaded Python 3.7.3.)
- Make sure you select the Install launcher for all users and Add Python 3.7 to PATH checkboxes. The latter places the interpreter in the execution path. For older versions of Python that do not support the Add Python to Path checkbox, see Step 6.
- Select Install Now – the recommended installation options.
- Make sure python is correctly installed and working. Open the command line and type python
```shell
>Python
```
If python doesn't work,you may have to Add it's Path to Environment Variables manually.



#### on Linux
To see which version of Python 3 you have installed, open a command prompt and run
```shell
$ python3 --version
```
If you are using Ubuntu 16.10 or newer, then you can easily install Python 3.6 with the following commands:
```shell
$ sudo apt-get update
$ sudo apt-get install python3.6
```
#### on MacOS
 - Launch Terminal. Go to Launchpad – Other – Terminal.
 - Install HomeBrew. Go to command line and type the following command
```shell
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
``` 
- Install Python3 with Brew. Enter brew command into terminal
```shell
brew install python3 
```
If python doesn't work,you may have to Add it's Path to Environment Variables manually.

## Usage
once the script is executed, you only have to input one of two choices 
- Collect new baseline
- Start monitoring with already collected baseline

### Passing arguments
Executing the script without passing any command line argument will monitor the path directory of the script,
in order to monitor the directory of your choosing, you have to pass the directory as an argument as follows 
```shell
./script path/to/directory/to/monitor
```


### Executing the script : 

#### Python
Open terminal 
```shell
python3 path/to/script.py
```

#### Powershell
##### On Windows
open powershell and type
```shell
cd path/to/script
./script.ps1
```
##### On linux and MacOS
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
```shell
brew install --cask powershell
```
```shell
$ pwsh
cd  path/to/script
./script.ps1
```

#### Bash
##### On linux or MacOS
```shell
$ sh /path/to/script
```
or
```shell 
$ cd /directory/with/script
$ ./executable
#----------------
$ chmod +x script     # only required if your file is not already executable
```
##### On Windows 10
Execute Shell Script file same as on a linux based system using WSL (Windows Subsystem for Linux) or by installing a linux virtual machine.





## Contributing
Pull requests are welcome. Feel free to take the code and make it your own, expand on it and put it in your portfolio, while mentioning the original authors.

