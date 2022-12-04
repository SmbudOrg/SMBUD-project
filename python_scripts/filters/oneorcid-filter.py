import xml.etree.ElementTree as ET

#file di input e output (nella stessa directory del file python)
inputfile = "d2-book.xml"
outputfile = "book-oneorcid.xml"

n = 0

with open(inputfile) as input:
    print("File opened")
    input_tree = ET.parse(inputfile)
    print("Input tree built")
    input_root = input_tree.getroot()
    print("Input root assigned")

    output_root = ET.Element("dblp")

    for element in list(input_root):
        hasorcid = True
        orcid = element.findall("./*[@orcid]")
        
        if(len(orcid) > 0):
            n = n+1
            output_root.append(element)
        
        
print("Elements with orcid: " + str(n))                     
output_tree = ET.ElementTree(output_root)
print("Output tree built")
output_tree.write(outputfile)
print("Process ended")
