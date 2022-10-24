import xml.etree.ElementTree as ET

#file di input (nella stessa directory del file python)
inputfile = "book-oneorcid.xml"

#elenco di attributi da controllare
tags = ["author", "editor", "title", "booktitle","pages","year","address","journal","volume",
    "number","month","url","ee","cdrom","cite","publisher","note","crossref", "isbn","series",
    "school","chapter","publnr"]

n = [0 for i in range(0, len(tags))]
m = [0 for i in range(0, len(tags))]

with open(inputfile) as input:
    print("File opened")
    input_tree = ET.parse(inputfile)
    print("Input tree built")
    input_root = input_tree.getroot()
    
    for element in list(input_root):
        for i in range(0, len(tags)):
            a = element.findall(tags[i])
            if(len(a) > 0):
                n[i] = n[i]+1
            if(len(a) > 1):
                m[i] = m[i]+1

for i in range(0, len(tags)):
    print(tags[i] + ": ", n[i], "(multiple: ", m[i], ")")

