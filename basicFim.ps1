# function Test-Administrator()
# {  
#     $user = [Security.Principal.WindowsIdentity]::GetCurrent();
#     (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
# }



# Check if script is executed with Admin privileges
# if (Test-Administrator == false){
#     Write-Host "Please run as Admin"
#     Break
# }



# Check if Script is called with first argument as monitoring directory
# else monitoring directpry is the current working directory
$param1=$args[0]
$param2=$args[1]
if ($param2 -ne $null) {
    Write-Host "Too many arguments ! "
    Write-Host "Exiting..."
    Break
}
if ($param1 -eq $null){
    $monitoring_dir = Get-Location
} else {
    if (Test-Path -Path $param1){
        $monitoring_dir=$param1
    }else{
        Write-Host "The Directory you entered doesn't exist ! "
        Write-Host "Exiting ..."
        Break
    }
}
$baseline_path = "$monitoring_dir/baseline.txt"


Function Calculate-File-Hash($filepath) {
    $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
    return $filehash
}


Function Erase-Baseline-If-Already-Exists() {
    $baselineExists = Test-Path -Path $baseline_path

    if ($baselineExists) {
        # Delete it
        Write-Host "Baseline already exists !"
        Write-Host "Deleting existing baseline ..."
        Write-Host "Creating new baseline ..."
        Remove-Item -Path $baseline_path
    }
}










#User input
Write-Host ""
Write-Host "What would you like to do?"
Write-Host ""
Write-Host "    A) Collect new Baseline?"
Write-Host "    B) Begin monitoring files with saved Baseline?"
Write-Host ""
$response = Read-Host -Prompt "Please enter 'A' or 'B'"
Write-Host ""

if ($response -eq "A".ToUpper()) {
    # Delete baseline.txt if it already exists
    Erase-Baseline-If-Already-Exists
    # Calculate Hash from the target files and store in baseline.txt
    # Collect all files in the target folder
    $files = Get-ChildItem -Path $monitoring_dir
    # $files = Get-ChildItem -Path .\Files

    # For each file, calculate the hash, and write to baseline.txt
    foreach ($f in $files) {
        $hash = Calculate-File-Hash $f.FullName
        "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath $baseline_path -Append
    }
    Write-Host "Baseline created successfully"
}

elseif ($response -eq "B".ToUpper()) {

    Write-Host "Start..."
    Write-Host "Monitoring Files"
    Write-Host "You will be notified of any changes here"
    Write-Host "For more details about changes made, see logs.txt file"
    Write-Host "Press [CTRL+C] to stop monitoring."
    
    $fileHashDictionary = @{}

    # Load file|hash from baseline.txt and store them in a dictionary
    $filePathsAndHashes = Get-Content -Path $baseline_path
    
    foreach ($f in $filePathsAndHashes) {
         $fileHashDictionary.add($f.Split("|")[0],$f.Split("|")[1])
    }

    # Begin (continuously) monitoring files with saved Baseline
    while ($true) {
        Start-Sleep -Seconds 1
        
        # $files = Get-ChildItem -Path .\Files
        $files = Get-ChildItem -Path $monitoring_dir
        

        # For each file, calculate the hash, and write to baseline.txt
        foreach ($f in $files) {
            $hash = Calculate-File-Hash $f.FullName
            #"$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append

            # Notify if a new file has been created
            if ($fileHashDictionary[$hash.Path] -eq $null) {
                # A new file has been created!
                Write-Host "$($hash.Path) has been created!" -ForegroundColor Green
            }
            else {

                # Notify if a new file has been changed
                if ($fileHashDictionary[$hash.Path] -eq $hash.Hash) {
                    # The file has not changed
                }
                else {
                    # File file has been compromised!, notify the user
                    Write-Host "$($hash.Path) has changed!!!" -ForegroundColor Yellow
                }
            }
        }

        foreach ($key in $fileHashDictionary.Keys) {
            $baselineFileStillExists = Test-Path -Path $key
            if (-Not $baselineFileStillExists) {
                # One of the baseline files must have been deleted, notify the user
                Write-Host "$($key) has been deleted!" -ForegroundColor DarkRed -BackgroundColor Gray
            }
        }
    }
}