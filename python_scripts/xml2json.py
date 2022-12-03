import xmltodict,json,os

folderpath = "dataset/"

for filename in os.listdir(folderpath):
    xml = open(folderpath+filename,"rb")
    f = open(filename.replace("xml","json"),"w")
    f.write(json.dumps(xmltodict.parse(xml), indent=4))
#!Disclaimer: non importare su spark i file direttamente convertiti, rimuovi prima dblp e "articles" e lascia solo le parentesi quadre 
