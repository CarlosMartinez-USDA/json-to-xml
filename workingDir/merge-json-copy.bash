cat *.json
for file in *.json; do
	sed -i '1i {\r\n\    "merged_json.json": [' "$file" && #adds data tag to the beginning of JSON file
	echo '}\r\n\ ]}' "$file" &&
	ls >> "$file" && ## echos data tag at end of JSON file 
