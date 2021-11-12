for file in *.json; do
  sed -i '1i <data>' "$file" &&
  sed -e 's/\&[^amp;|^apos;|^quot;|^lt;|^gt;]/\&amp;/gi' "$file"  &&
  echo '</data>' >> "$file" &&
  ls "$file" > added_data_output.text
done
