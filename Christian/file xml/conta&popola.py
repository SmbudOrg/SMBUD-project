# da usare dopo tag-extractor, permette di creare file xml con num_ele specificato 

from random import random
import xml.etree.ElementTree as ET
NUM_ELE = 2000

nomefile =  "d1.xml"
nf = nomefile.replace(".xml", "")

#article|inproceedings|proceedings|book|incollection|phdthesis|mastersthesis|www|person|data #
tags = ["article","inproceedings","proceedings","book","incollection","phdthesis","mastersthesis","www","person","data"]
l = []
n=0
for tag in tags:
    n = n+1
    inputfile = nf + "-" + tag + ".xml"
    conta = 0
    with open(inputfile) as input:
        input_tree = ET.parse(inputfile)
        input_root = input_tree.getroot()
        for child in list(input_root):
            if (child.tag == tag):
                conta = conta + 1
    l.append(conta)
    print(tag + " tot: " + str(l[n-1]))

n = 0 
for tag in tags:
    n = n + 1
    b = 0
    inputfile = nf + "-" + tag + ".xml"
    outputfile = "d-" + tag + ".xml"

    # insertion rate
    if(l[n-1] < NUM_ELE):
        r=1
    else: r = NUM_ELE / l[n-1]

    with open(inputfile) as input:
        input_tree = ET.parse(inputfile)
        input_root = input_tree.getroot()
        output_root = ET.Element("dblp")

        for child in list(input_root):
            if (child.tag == tag):
                if(random() > (1-r)):
                    output_root.append(child)
                    b = b + 1
      
    output_tree = ET.ElementTree(output_root)
    output_tree.write(outputfile)
    print(tag + " add: " + str(b))  
