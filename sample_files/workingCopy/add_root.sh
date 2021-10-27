for file in *.json; do
  sed -i '1i <data>' &&
  sed 's/&/&amp;/g'  &&
  echo '</data>' >> "$file"
done