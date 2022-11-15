import json
import random
import sys

inputfile = "db_conTesti.json"
outputfile = "dataset_conrefs.json"

data = json.load(open(inputfile,"r",encoding="utf-8"))

for i in range(0,len(data)):
    data[i]["references"] = {}
    data[i]["references"] = [data[random.randint(0,len(data)-1)]["_id"] for i in range(0,random.randint(0,10))]

json.dump(data, open(outputfile,"w",encoding="utf-8"), indent = 4)
