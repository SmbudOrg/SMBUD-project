import xml.etree.ElementTree as ET

inputfile = "dblp.xml"
outputfile = "dblp-articles.xml"

n = 0
a = 0

with open(inputfile) as input:
    print("File opened")
    input_tree = ET.parse(inputfile)
    print("Input tree built")
    input_root = input_tree.getroot()
    print("Input root assigned")

    output_root = ET.Element("dblp")

    for child in list(input_root):
        if (child.tag == "article"):
            output_root.append(child)
            a = a+1
            #print(child.tag, child.attrib)
        n = n+1
        if (n % 5000 == 0):
            print("Elements considered: " + str(n/1000) + "k")
        
output_tree = ET.ElementTree(output_root)
print("Output tree built")
output_tree.write(outputfile)
print("Process ended")
print("Articles: " + str(a))
print("Total nodes: " + str(n/1000) + "k")