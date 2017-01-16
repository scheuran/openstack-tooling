

TMP_FILE=uninstall_pip_packages.tmp
rm -f $TMP_FILE
# read output from 'pip freeze' into var $array
mapfile -t array < <(pip freeze)

for var in "${array[@]}"
do
  if [[ $var == -e* ]]; then
      package=$(echo $var | grep -oP "git:\/\/.*\/\K(\w*[-]*\w*)")
  else
      package=$var
  fi
  echo $package >> $TMP_FILE

done

sudo pip uninstall -yr $TMP_FILE
rm -f $TMP_FILE
