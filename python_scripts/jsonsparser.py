import ijson,json
n = 500
i = 0
outf = open("dblp_data_sparse.json","a")
with open("dblp.json", "rb") as f:
    for record in ijson.items(f, 'dblp.data.item'):
        if(i<n):
            outf.write(json.dumps(record, indent = 4)+",")
        else:
            outf.write(json.dumps(record,indent = 4))
            break
        i=i+1
