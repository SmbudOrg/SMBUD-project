import xml.etree.ElementTree as ET

#file di input e output (nella stessa directory del file python)
inputfile = "database.xml"
outputfile = "prova.xml"

with open(inputfile) as input:
    print("File opened")
    input_tree = ET.parse(inputfile)
    print("Input tree built")
    input_root = input_tree.getroot()

    for element in list(input_root):
        author = element.findall("author")
        editor = element.findall("editor")

        for a in author:
            if("orcid" not in a.attrib):
                a.set("orcid", a.text)
        for e in editor:
            if("orcid" not in e.attrib):
                a.set("orcid", e.text)
        

input_tree.write(outputfile)
print("Process ended")
