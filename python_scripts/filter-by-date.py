import xml.etree.ElementTree as ET

#file di input e output (nella stessa directory del file python)
inputfile = "database.xml"
outputfile = "prova.xml"

#anno minimo (incluso)
minyear = 1980
#anno massimo (incluso)
maxyear = 2020
#set to True per tenere i record che non hanno specificato l'anno
keepunknown = True

with open(inputfile) as input:
    print("File opened")
    input_tree = ET.parse(inputfile)
    print("Input tree built")
    input_root = input_tree.getroot()
    print("Input root assigned")

    output_root = ET.Element("dblp")

    for child in list(input_root):
        year = child.find("year")
        if (year is None and keepunknown):
            output_root.append(child)
        if (year is not None):
            year = int(year.text)
            if(year >= minyear and year <= maxyear):
                output_root.append(child)
        
output_tree = ET.ElementTree(output_root)
print("Output tree built")
output_tree.write(outputfile)
print("Process ended")
