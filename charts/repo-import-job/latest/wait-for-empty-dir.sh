count_files() {
  count=$(find /import/admin/incoming | grep ".xml" | wc -l)
  echo $count
}

currentFileCount=$(count_files)
while [ $currentFileCount -gt 0 ]
do
  echo "Still waiting. Current file count is ${currentFileCount}"
  sleep 1
  currentFileCount=$(count_files)
done

echo "No files remaining. We wait another 30 seconds."
sleep 30
# Kill the importer:
importerPid=$(pgrep java)
kill $importerPid