# da usare per dividere il file xml nelle varie categorie 
import xml.etree.ElementTree as ET

#article|inproceedings|proceedings|book|incollection|phdthesis|mastersthesis|www|person|data #
tags = ["article","inproceedings","proceedings","book","incollection","phdthesis","mastersthesis","www","person","data"]
for tag in tags:
    inputfile = "d1.xml"
    outputfile = inputfile.replace(".xml", "") + "-" + tag + ".xml"

    conta = 0
    
    with open(inputfile) as input:
        input_tree = ET.parse(inputfile)
        input_root = input_tree.getroot()
        output_root = ET.Element("dblp")

        for child in list(input_root):
            if (child.tag == tag):
                output_root.append(child)
                conta = conta + 1
            
    output_tree = ET.ElementTree(output_root)
    output_tree.write(outputfile)

    print(tag + " tot: " + str(conta))
