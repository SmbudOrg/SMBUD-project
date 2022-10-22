import xmltodict,gzip,json
xml = gzip.GzipFile("dblp.xml.gz")
f = open("dblp.json","w")
f.write(json.dumps(xmltodict.parse(xml), indent=4))

