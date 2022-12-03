import xmltodict,json,os

folderpath = "dataset/"
inputname = "dataset/book-db.xml"
outputname ="dataset/book-db.json"
for filename in os.listdir(folderpath):
    xml = open(folderpath+filename,"rb")
    f = open(filename.replace("xml","json"),"w")
    f.write(json.dumps(xmltodict.parse(xml), indent=4))


