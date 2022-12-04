import xml.etree.ElementTree as ET
import json

inputfile = "Datasets (xml)/book-db.xml"
outputfile = "Datasets (json)/book-db.json"

data_out = []

#author, editor e series hanno una key e quindi sono presenti separatamente nello script
#ALTRI SOTTOELEMENTI:
#sottoelementi che sono stringhe semplici
subelements = ["title", "publisher", "crossref"]
#sottoelementi che sono array di stringhe
arraysubelements = ["keyword", "isbn", "ee"]
#sottoelementi che sono int semplici
intsubelements = ["year", "citations", "pages", "volume"]

with open(inputfile, "r") as f_in:
    input_tree = ET.parse(f_in)
    print("Input tree built")
    input_root = input_tree.getroot()

    for element in list(input_root):
        pub = {}
        pub["key"] = element.get("key")

        authors = element.findall("author")
        if (authors is not None and len(authors)>0):
            pub["author"] = []
            for a in authors:
                json_a = {"orcid": a.get("orcid"), "name": a.text}
                pub["author"].append(json_a)
        
        editors = element.findall("editor")
        if (editors is not None and len(editors)>0):
            pub["editor"] = []
            for e in editors:
                json_e = {"orcid": e.get("orcid"), "name": e.text}
                pub["editor"].append(json_e)
        
        series = element.find("series")
        if (series is not None):
            pub["series"] = {"key": series.get("key"), "title": series.text}
        
        for s in subelements:
            if (element.find(s) is not None):
                pub[s] = element.find(s).text
        
        for asubelement in arraysubelements:
            json_as = element.findall(asubelement)
            if (json_as is not None and len(json_as)>0):
                pub[asubelement] = [i.text for i in json_as]
        
        for intsubel in intsubelements:
            if (element.find(intsubel) is not None):
                pub[intsubel] = int(element.find(intsubel).text)

        data_out.append(pub)

print("Parsing ended")

with open(outputfile, "w") as f_out:
    json.dump(data_out, f_out, indent=4)
