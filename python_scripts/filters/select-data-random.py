from random import random
import xml.etree.ElementTree as ET

#file di input e output (nella stessa directory del file python)
inputfile = "dblp.xml"
outputfile = "dblp-sparse-random.xml"
#probabilità di selezionare l'elemento
p = 0.1


with open(inputfile) as input:
    print("File opened")
    input_tree = ET.parse(inputfile)
    print("Input tree built")
    input_root = input_tree.getroot()
    print("Input root assigned")

    output_root = ET.Element("dblp")

    for child in list(input_root):
        x = random()
        if (x < p):
            output_root.append(child)
        
output_tree = ET.ElementTree(output_root)
print("Output tree built")
output_tree.write(outputfile)
print("Process ended")
