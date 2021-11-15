for file in *.json; do
  sed -i 's/\<br\>|\<br\/\gi' "$file" &&
  sed -i 's/\</\&lt\;/gi' "$file" &&
  ls "$file" >> added_data_output.text
done
