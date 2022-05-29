@echo OFF

echo #-------------------------------
echo # Convert from excel file to csv.
echo #-------------------------------
powershell -ExecutionPolicy RemoteSigned -File ./scripts/excel2csv.ps1 -Args -json_path "./config/excel_import_setting.json"

echo #-------------------------------
echo # Convert from csv file to json.
echo #-------------------------------
powershell -ExecutionPolicy RemoteSigned -File ./scripts/csv2json.ps1 -Args -csv_path "./schedule.csv" -output_path "./schedule_without_root.json"

echo #-------------------------------
echo # Add root element to json
echo #-------------------------------
powershell -ExecutionPolicy RemoteSigned -File ./scripts/addroot.ps1 -Args -json_path "./schedule_without_root.json" -output_path "./schedule.json"

echo #-------------------------------
echo # Convert from pu file to svg.
echo #-------------------------------
powershell -ExecutionPolicy RemoteSigned -File ./scripts/pu2svg.ps1 -Args -pu_path "./config/gantt_chart.pu"

echo #-------------------------------
echo # Clean up
echo #-------------------------------
echo Start processing
del "./schedule.csv"
del "./schedule_without_root.json"
del "./schedule.json"
del $$$
cd ./config
move gantt_chart.svg ../
cd ../
echo Processing is finished.


