for file in *.json; do
sed -e 's/&[^amp;|^apos;|^quot;|^lt;|^gt;]/\&amp;/gi' input.xml "$file"  &&
echo '</data>' >> "$file"
done