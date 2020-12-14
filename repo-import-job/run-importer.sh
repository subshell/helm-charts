count_files() {
  result=$(find $1 -type f | wc -l)
  echo "$result"
}

cd /sophora || exit
echo "Starting importer."
java -cp classpath org.springframework.boot.loader.JarLauncher
echo "Importer stopped."

success=$(count_files /import/admin/success)
failure=$(count_files /import/admin/failure)

printf "successful imports: %i\t import failures: %i\n" "$success" "$failure"

if [ "$failure" -gt 0 ]; then
  # error
  echo "import was not successful"
  echo "failures"
  echo "===="
  ls -R /import/admin/failure
  exit 1
else
  echo "import was successful"
  exit 0
fi

