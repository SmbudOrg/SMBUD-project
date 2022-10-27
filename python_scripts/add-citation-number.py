from random import random
import xml.etree.ElementTree as ET

#file di input e output (nella stessa directory del file python)
inputfile = "book-db-nocit.xml"
outputfile = "book-db.xml"

#probability to assign citation number
p = 0.5
#max number of citations
maxcit = 150


with open(inputfile) as input:
    print("File opened")
    input_tree = ET.parse(inputfile)
    print("Input tree built")
    input_root = input_tree.getroot()

    for element in list(input_root):
        x = random()
        if(x >= p):
            y = int(random() * maxcit)
            cit = ET.SubElement(element, "citations")
            cit.text = str(y)
        

input_tree.write(outputfile)
print("Process ended")
