#-----------------------------------------------------------------------------------------------#
#
# @file         E2S4K.ps1
# @Description  N.A
# @Author       H.Nakayama
#
#-----------------------------------------------------------------------------------------------#
#-----------------------------------------------------------------------------------------------#
# Import
#-----------------------------------------------------------------------------------------------#
# Nothing

#-----------------------------------------------------------------------------------------------#
# Environment setting
#-----------------------------------------------------------------------------------------------#
# Set-StrictMode -Version Latest

#-----------------------------------------------------------------------------------------------#
# Parameters 
#-----------------------------------------------------------------------------------------------#
#Param([String]$csv_path = "", [String]$output_path = "")

#-----------------------------------------------------------------------------------------------#
# Functions
#-----------------------------------------------------------------------------------------------#
#-----------------------------------------------------------#
#
# Entry Point ( Called by end of this file )
#
#-----------------------------------------------------------#
function main() {
    if ( $false ) {
        Write-Host "Aruguments are invalid. Please refer to the following"
        Write-Host "  -xxx [FileName]"
    }
    else {
        Write-Host "#-------------------------------"
        Write-Host "# Convert from excel file to csv."
        Write-Host "#-------------------------------"
        Write-Host "Start processing..."
        ./scripts/excel2csv.ps1 -json_path "./config/excel_import_setting.json"
        Write-Host "Processing is finished."

        Write-Host "#-------------------------------"
        Write-Host "# Convert from csv file to json."
        Write-Host "#-------------------------------"
        Write-Host "Start processing..."
        ./scripts/csv2json.ps1 -csv_path "./schedule.csv" -output_path "./schedule_without_root.json"
        Write-Host "Processing is finished."

        Write-Host "#-------------------------------"
        Write-Host "# Add root element to json      "
        Write-Host "#-------------------------------"
        Write-Host "Start processing..."
        ./scripts/addroot.ps1 -json_path "./schedule_without_root.json" -output_path "./schedule.json"
        Write-Host "Processing is finished."

        Write-Host "#-------------------------------"
        Write-Host "# Convert from pu file to svg.  "
        Write-Host "#-------------------------------"
        Write-Host "Start processing..."
        ./scripts/pu2svg.ps1 -pu_path "./config/gantt_chart.pu"
        Write-Host "Processing is finished."

        Write-Host "#-------------------------------"
        Write-Host "# Clean up                      "
        Write-Host "#-------------------------------"
        Write-Host "Start processing..."
        Remove-Item -Path "./schedule.csv"
        Remove-Item -Path "./schedule_without_root.json"
        Remove-Item -Path "./schedule.json"
        Move-Item ./config/gantt_chart.svg ./gantt_chart.svg -force 
        Write-Host "Processing is finished."
    }
}

#-----------------------------------------------------------------------------------------------#
# Code block 
#-----------------------------------------------------------------------------------------------#
# Call the main function.
main

#-----------------------------------------------------------------------------------------------#
