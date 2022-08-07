for file in *.json; do
  sed -i '1i <data>' "$file" && #adds data tag to the beginning of JSON file
  sed -i 's/\&[^amp;|^apos;|^quot;|^lt;|^gt;]/\&amp;/gi' "$file"  && ##corrects invalid use of ampersand
  sed -i 's/\<br\>/\br\//g' "$file" && ##adds forwardslash to the end of 'br' tag
 ##sed -i 's/ </\&lt;/g' "$file" && # changes less than symbol to ampersand-lt-semicolon. NOT READY FOR PRODUCTION
 ##sed -i 's/ > / \&gt; /g' "$file" && # changes greater than symbol to ampersand-gt-semicolon NOT READY FOR PRODUCTION
  echo '</data>' >> "$file" && ## echos data tag at end of JSON file 
  ls "$file" >> added_data_output.txt 
done ##creates a log of all files written to then closes
