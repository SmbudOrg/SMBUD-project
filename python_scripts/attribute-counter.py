import xml.etree.ElementTree as ET

#file di input (nella stessa directory del file python)
inputfile = "book-db.xml"

#elenco di sottoelementi da contare
elements = ["author", "editor", "title", "booktitle","pages","year","address","journal","volume",
    "number","month","url","ee","cdrom","cite","publisher","note","crossref", "isbn","series",
    "school","chapter","publnr"]

#elenco di attributi da contare
attributes = ["key", "mdate", "publtype", "cdate"]

n = [0 for i in range(0, len(elements))]
m = [0 for i in range(0, len(elements))]
p = [0 for i in range(0, len(attributes))]
t = 0


with open(inputfile) as input:
    print("File opened")
    input_tree = ET.parse(inputfile)
    print("Input tree built")
    input_root = input_tree.getroot()
    
    for element in list(input_root):
        t = t+1
        for i in range(0, len(elements)):
            a = element.findall(elements[i])
            if(len(a) > 0):
                n[i] = n[i]+1
            if(len(a) > 1):
                m[i] = m[i]+1
        for j in range(0, len(attributes)):
            if (attributes[j] in element.attrib):
                p[j] = p[j] + 1

print("TOTAL ELEMENTS: ", t)
for j in range(0, len(attributes)):
    print(attributes[j] + ": ", p[j])
for i in range(0, len(elements)):
    print(elements[i] + ": ", n[i], "(multiple: ", m[i], ")")

