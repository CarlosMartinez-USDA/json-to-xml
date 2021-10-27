for file in *.json; do
  sed -i '1i <root>' "$file" &&
  echo '</root>' >> "$file"
done