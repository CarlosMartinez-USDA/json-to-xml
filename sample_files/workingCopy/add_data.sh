for file find "-iname '*.json';" do
  sed -i '1i <data>' "$file" &&
  's/&/&amp;/g' "$file" && do
  echo '</data>' >> "$file" &&
 ;
end