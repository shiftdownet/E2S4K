#-----------------------------------------------------------------------------------------------#
#
# @file         csv2json.ps1
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
Param([String]$csv_path = "", [String]$output_path = "")

#-----------------------------------------------------------------------------------------------#
# Functions
#-----------------------------------------------------------------------------------------------#
#-----------------------------------------------------------#
#
# Entry Point ( Called by end of this file )
#
#-----------------------------------------------------------#
function main() {
    if ( $csv_path -eq "" ) {
        Write-Host "Aruguments are invalid. Please refer to the following"
        Write-Host "  -csv_path [FileName]"
    }
    else {
        if ( $output_path -eq "" ){
            $output_path = [System.IO.Path]::GetFileNameWithoutExtension($csv_path) + ".json"
        }

        Import-CSV $csv_path -Encoding Default | ConvertTo-Json | Out-File -FilePath $output_path -Encoding UTF8
    }
}

#-----------------------------------------------------------------------------------------------#
# Code block 
#-----------------------------------------------------------------------------------------------#
# Call the main function.
main

#-----------------------------------------------------------------------------------------------#
