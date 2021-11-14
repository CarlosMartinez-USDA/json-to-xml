# JSON-to-MODS XSLT Transformation

**Task:** Transform [Treesearch](https://www.fs.usda.gov/treesearch/) JSON files to MODS XML records for ingest into Unified Repository.

**Materials**: Treesearch metadata in JSON format from the [United States Forest Service (USFS)](https://www.fs.usda.gov/).

## Transformation process

The _[json_to_mods.xsl](https://github.com/CarlosMtz3/json-to-xml/blob/master/json-to-mods.xsl)_ utilizes the following formats and schema to transform the JSON format into MODS.

-   [JSON](https://www.json.org/json-en.html): (JavaScript Object Notation)
-   [XPath 3.1](https://www.w3.org/TR/xpath-31/): (XML Path Language)
-   [XSLT 3.0](https://www.w3.org/TR/xslt-30/): (Extensible Stylesheet Language Transformations)
-   [MODS 3.7](https://www.loc.gov/standards/mods/v3/mods-3-7.xsd) : (Metadata Object Description Schema)

*Each JSON file is first transformed to XML, upon which the XML produced is mapped its respective MODS element.

## JSON to MODS Transformation Flowchart
```mermaid
flowchart LR
A[JSON] --> B((XSLT3.0))
B-->B.1((XPath 3.1))-->C
B --transforms_to--> C{XML}
C --maps to--> D[MODS 3.7]
style A fill:#f9f,stroke:#333,stroke-width:4px 
style B fill:#bbf,stroke:#f66,stroke-width:2px,color:#fff,stroke-dasharray: 5 5
style B.1 fill:#bbf,stroke:#f66,stroke-width:2px,color:#fff,stroke-dasharray: 5 5
style C fill:#9fc5e8, stroke:#f66, stroke-dasharray: 5 5
style D fill:#9fc5e8,stroke:#333,stroke-width:4px 
```
 ###### *If the UML does not render, the image below is how the code above would render using Mermaid.

<a href="https://ibb.co/bbkKx8n"><img src="https://i.ibb.co/QD4KZ1G/json-to-mods-transformation-flowchart.png" alt="json-to-mods-transformation-flowchart" border="0" /></a>

 ## Preparing JSON Files for XSLT Transformation


1.  Open the source_files folder
2.  Locate the following shell scripts
	 (a) merge_json.sh 
	 (b) data_amp_add.sh
3.  Run the merge_json.sh
4.  Run the data_amp_add.sh
5.  Open a JSON file in Oxygen
6. Verify it contains the`<data>  </data>`at the beginning of the file and at the end of the file. 

## Create a Transformatio Scenario or Select the Debugging Layout
1) Choose the json-to-mods.xsl as the transformation stylesheet. 
2) If you're creating a scenario, set the output page as desired. 
3) DO NOT set any parameters. This is taken care of by the new testing parameters added to the params-cm.xsl file. 
4) Run the scenario or choose the debugging button to transform JSON to MODS
# MODS: Identifier and Location 
## MODS:Identifiers 
The primary identifiers found in the Treesearch metadata are: ***doi, product_id, and treesearch_pub_id.*** 

From these **location** elements to the surrogate record and the resource itself are built to provide access. 

## MODS:location and url access[*](https://www.loc.gov/standards/mods/userguide/location.html#url)

**Definition** - Indicates the type of resource that the user will access when following the URL link.
**Application** 
(_This attribute is particularly useful to provide a flag in the context of OAI service providers harvesting metadata._)
 #### The following values may be used with the access attribute:
 - **preview** – Indicates a link to a thumbnail or snippet of text.
 - **raw object** – Indicates a direct link to the object described (e.g., a jpg or pdf document). Used only when the object is represented by a single file.
- **object in context** – Indicates a link to the object within the context of its environment (with associated metadata, navigation, etc.)
######  Information related to url access may ben found at: https://www.loc.gov/standards/mods/userguide/location.html#url
# Issues

## ISSUE #1: Page Numbering


  - [X] Task Complete?  **Yes. Resolved.**
 ***Page numbers are not consistently correct.***	
- When the following JSON string key values are present: 
	-	pub_start_page andpub_end_page,
	-	pub_page. 
 - No issues are present with page numbers.
 - When they are not, they must be derived from the “pub_publicaton” or citation” key values. 
		- Both of these files aree strings of text, with inconsistent formatting.
	-  While they mostly do contain some pagination information
	- It is difficult to get the correct data from a string of text
------
# ISSUE #2: random "station_id" acronym

  - [X] Task Complete?  **Yes. Resolved.**
**Description:** Extraneous “station_id” acronym appearing just outside the last author name tag. 
	 -  Have not been able to determine it’s origin. 
	 -  See screenshot below
<a href="https://ibb.co/BrZ0kQ5"><img src="https://i.ibb.co/fnpjJyz/random-station-id.png" alt="random-station-id" border="0"></a>


# Issue  3: invalid characters usage
**Issue**: Several TreeSearch files contain an invalid characters that will render invalid when the XML processor attempts to transform them
The filenames containing the issues are listed below. Some files contain more than one issue so they are listed twice. 

**Resolution:** The shell script provided to add `<data></data>` tags to the beginning and end of each document, adds a second statement and has resolved 3a. With more time, issues 3b, and 3c can also be resolved. 

 The following error message is rendered:
## Issue 3a:  "&"

**Filenames:** 
 - [x] A-26207.json
 - [x] A-26377.json
 - [x] A-29788.json
 - [x] A-29790.json
 - [x] A-29793.json

**Description:** *"The entity name must immediately follow the '&' in the entity reference."*
- [x] **Task Complete?** Yes
	
 

The shell script responsible for adding `<data></data>` to the beginning and end of each file, also contains a **sed** corrects this issue
*The statement below corrects the invalid ampersand*
  
      sed -i 's/\&[^amp;|^apos;|^quot;|^lt;|^gt;]/\&amp;/gi' "

## Issue 3b: "<" usage of less-than  
**Filename:** A-29760.json 
- [ ] **Task Complete?**  No. Possible to fix shell script. 
**Description:** The content of elements must consist of well-formed character data or markup.

	- The file contains the "<" symbol within the abstract. This is treated as an invalid character and thus renders and error.

> abstract: ...(diameter at breast height <6 in) with suppressed> growth...

Once the problem is corrected manually, it produces valid MODS metadata, and a valid JSON archival replica. 
This issue can be resolved if the shell script is improved to handle preprocess this bad character prior to transformation. 

## Issue 3c: "`<br>`"

<!--stackedit_data:
eyJoaXN0b3J5IjpbNTY2MTQ2MTE2XX0=
-->




	



<!--stackedit_data:
eyJoaXN0b3J5IjpbMTQ2MDA1MTA4MywxNDI1OTEwODYyLC0xMj
UyMDU4MzA0LDExODc0MDU5MDUsMzY0MDAzOTc5LC0zMjQ4NzA3
MiwxOTMzMzYzNjg5LDEzMzE4NDExNTcsMTQwMjA0NDEwMywxNz
U5ODM2NTUsODc1NTY2MzI1LC02ODg0OTQzOTMsLTY5MTYwMDc0
NiwxMTUwMDg1NjQ0LC00NjczNTA1NjcsMTc5NzM1OTM3MCwxOT
ExOTc1NjQ1XX0=
-->
