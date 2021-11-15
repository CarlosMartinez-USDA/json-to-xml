for file in *.json; do
  sed -i '1i <data>' "$file" &&
  sed -i 's/\&[^amp;|^apos;|^quot;|^lt;|^gt;]/\&amp;/gi' "$file"  &&
  sed -i 's|(<br>)|(<br/>)|gi' "$file" &&
  echo '</data>' >> "$file" &&
  ls "$file" >> added_data_output.text
done
