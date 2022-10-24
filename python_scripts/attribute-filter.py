import xml.etree.ElementTree as ET

#file di input e output (nella stessa directory del file python)
inputfile = "database.xml"
outputfile = "prova.xml"

#name of the attribute to filter by
attribute = "year"

with open(inputfile) as input:
    print("File opened")
    input_tree = ET.parse(inputfile)
    print("Input tree built")
    input_root = input_tree.getroot()
    print("Input root assigned")

    output_root = ET.Element("dblp")

    for element in list(input_root):
        a = element.find(attribute)
        
        if(a is not None):
            output_root.append(element)
        
                   
output_tree = ET.ElementTree(output_root)
print("Output tree built")
output_tree.write(outputfile)
print("Process ended")
