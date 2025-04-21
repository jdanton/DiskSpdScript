### Warning: This script is for educational purposes only. Use at your own risk.
### It is recommended to not do benchmarks on production systems.
### This script will run diskspd on two drives (P and V) for 5 iterations each.
### It will create a file named "iotest.dat" on each drive and save the results in C:\temp.
### Make sure to adjust the paths and parameters as needed.


# Define variables
$diskspdPath = "C:\diskspd\amd64\diskspd.exe"
$outputDirectory = "C:\temp"
$parameters = "-b8K -d60 -o4 -t32 -h -r -w25 -L -Z1G -c200G"
$drives = @("P", "V")
$iterations = 5

# Ensure the output directory exists
if (!(Test-Path -Path $outputDirectory)) {
    New-Item -ItemType Directory -Path $outputDirectory | Out-Null
}

# Loop through each drive
foreach ($drive in $drives) {
    for ($i = 1; $i -le $iterations; $i++) {
        # Generate timestamp
        $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

        # Construct the output file name
        $outputFile = "$outputDirectory\DiskSpeedResults_${drive}_Seq${i}_${timestamp}.txt"

        # Construct the command
        $filePath = "$drive`:\\iotest.dat"
        $command = "& `"$diskspdPath`" $parameters $filePath"

        # Run the command and save output to the new file
        Write-Output "Running diskspd on drive $drive (Iteration $i)..."
        Invoke-Expression "$command | Out-File -FilePath $outputFile -Encoding UTF8"
    }
}
