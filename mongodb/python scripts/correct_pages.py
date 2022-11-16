import json
import random
import sys

inputfile = "dblp_processed_10k.json"
outputfile = "correct_dblp_processed_10k.json"

data = json.load(open(inputfile,"r",encoding="utf-8"))
del data[0]
for i in range(0,len(data)):
    if("page_start" in data[i] and "page_end" in data[i]):
        data[i]["pages"] = {}
        data[i]["pages"] = {
            "page_start": data[i]["page_start"],
            "page_end": data[i]["page_end"]
        }
        del data[i]["page_start"]
        del data[i]["page_end"]
    
        

json.dump(data, open(outputfile,"w",encoding="utf-8"), indent = 4)