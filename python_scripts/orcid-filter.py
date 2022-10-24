import xml.etree.ElementTree as ET

#file di input e output (nella stessa directory del file python)
inputfile = "d2-article.xml"
outputfile = "article-withorcid.xml"

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
        author = element.findall("author")
        editor = element.findall("editor")
        if(len(author) == 0 and len(editor) == 0):
            break
        
        if (len(author) > 0):
            for a in author:
                if('orcid' not in a.attrib):
                    hasorcid = False
                    break  
        
        if(hasorcid and len(editor) > 0):
            for e in editor:
                if('orcid' not in e.attrib):
                    hasorcid = False
                    break
        
        if(hasorcid):
            n = n+1
            output_root.append(element)
        
        
print("Elements with orcid: " + str(n))                     
output_tree = ET.ElementTree(output_root)
print("Output tree built")
output_tree.write(outputfile)
print("Process ended")
