from random import random
import xml.etree.ElementTree as ET

#file di input e output (nella stessa directory del file python)
inputfile = "article-nopages.xml"
outputfile = "article-db.xml"

#min and max number of pages
minpages = 1
maxpages = 50

with open(inputfile) as input:
    print("File opened")
    input_tree = ET.parse(inputfile)
    print("Input tree built")
    input_root = input_tree.getroot()

    for element in list(input_root):
        pages = element.find("pages")
        if(pages is not None):
            n = int(minpages + random() * (maxpages-minpages))
            pages.text = str(n)
        

input_tree.write(outputfile)
print("Process ended")
