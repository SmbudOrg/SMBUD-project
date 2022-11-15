import json
import random

inputfile = "dataset_conTestieRefs.json"
outputfile = "dataset_conTestieRefs_PagesModificate.json"

with open(inputfile, "r", encoding="utf-8") as input:
    data = json.load(input)

for i in range(0, len(data)):

    if ("page_start" in data[i] or "page_end" in data[i]):
                pages = {
                    "page_start": data[i]["page_start"],
                    "page_end": data[i]["page_end"]
                }
                data[i]["pages"]=pages
                del data[i]["page_start"]
                del data[i]["page_end"]

with open(outputfile, "w", encoding="utf-8") as output:
    json.dump(data, output, indent=4)