#-----------------------------------------------------------------------------------------------#
#
# @file         excel2csv.ps1
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
Param([String]$json_path = "")

#-----------------------------------------------------------------------------------------------#
# Functions
#-----------------------------------------------------------------------------------------------#
#-----------------------------------------------------------#
#
# Entry Point ( Called by end of this file )
#
#-----------------------------------------------------------#
function main() {
    if ( $json_path -eq "" ) {
        Write-Host "Aruguments are invalid. Please refer to the following"
        Write-Host "  -json_path [FileName]"
    }
    else {
        $format_json = Get-Content $json_path | Out-String | ConvertFrom-Json
        $format_json | ForEach-Object {
            task $_
        }
    }
}

#-----------------------------------------------------------#
#
# Procede one of the task based on $setting that is json format.
#
#-----------------------------------------------------------#
function task($setting) {
    $excel = New-Object -ComObject Excel.Application

    try {
        $excel.Visible = $false
        $excel.DisplayAlerts = $false
        Write-Host $setting.import_from.path
        $file_path = (Resolve-Path $setting.import_from.path).Path
        Write-Host Opening $file_path ...

        $book = $excel.Workbooks.Open($file_path)
        $sheet = $book.WorkSheets.item($setting.import_from.sheet)

        $records = [PSCustomObject]@()

        Write-Host Now loading ...
        for ( $row = (starts_position $sheet $setting); $row -le (ends_position $sheet $setting); $row++) {
            $record = [PSCustomObject]@{}
            $part_blank = $false
            $all_blank = $true

            $setting.import_from.fields | ForEach-Object {
                $value = $sheet.Cells( $row, $_.column ).Value()

                if ( $null -ne $value ) {
                    if ( $null -ne $_.format ){ 
                        if ( $_.format -eq "string" ){
                            $value = [String]$value
                        }elseif ( $_.format -eq "date" ){
                            $value  = $value.ToString("yyyy/MM/dd")
                        }elseif ( $_.format -eq "percent" ){
                            $value  = [Int64]($value * 100)
                        }
                    }
                }

                $record | add-member -membertype noteproperty -name $_.name -value $value
                
                if ( $null -eq $value ) {
                    $part_blank = $true
                }
                if ( $null -ne $value ) {
                    $all_blank = $false
                }
            }
            if ( $setting.import_from.records.blank -eq "skip" ) {
                if ( $setting.import_from.records.blank_condition -eq "or" ) {
                    if ( $part_blank -eq $false ) {
                        $records += $record
                    }
                }
                else {
                    if ( $all_blank -eq $false ) {
                        $records += $record
                    }
                }
            }
            else {
                $records += $record
            }
        }
        
        Write-Host Exporting to $format_json.export_name ...
        $records | Export-Csv -path $format_json.export_name -Encoding UTF8
    }
    finally {
        if ($null -ne $book) {
            [void]$book.Close($false)
            [void]([System.Runtime.Interopservices.Marshal]::ReleaseComObject($book))
        }
        [void]$excel.Quit()
        [void]([System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel))
    }
}

#-----------------------------------------------------------#
#
# Row starts position
#
#-----------------------------------------------------------#
function starts_position($sheet, $setting) {
    if ( $setting.import_from.records.start_condition.mode -eq "specified" ) {
        return [Int64]$setting.import_from.records.start_condition.at
    }
    elseif ( $setting.import_from.records.start_condition.mode -eq "keyword" ) {
        # Not implemented yet.
    }
    return 1
}

#-----------------------------------------------------------#
#
# Row ends position
#
#-----------------------------------------------------------#
function ends_position($sheet, $setting) {
    if ( $setting.import_from.records.end_condition.mode -eq "specified" ) {
        return [Int64]$setting.import_from.records.end_condition.at
    }
    elseif ( $setting.import_from.records.end_condition.mode -eq "used_range" ) {
        return $sheet.UsedRange().Rows($sheet.UsedRange().Rows().Count()).Row()
    }
    elseif ( $setting.import_from.records.end_condition.mode -eq "keyword" ) {
        # Not implemented yet.
    }
    return 1
}

#-----------------------------------------------------------------------------------------------#
# Code block 
#-----------------------------------------------------------------------------------------------#
# Call the main function.
Write-Host Start processing.
main
Write-Host Processing is finished.

#-----------------------------------------------------------------------------------------------#
