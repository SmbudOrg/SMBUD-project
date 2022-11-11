import json
import random

inputfile = "dataset-prova.json"
outputfile = "prova2.json"

#probability of assigning an email
emailp = 0.8
#probability of assigning a bio
biop = 0.7

universities = [
    "Western Norway University of Applied Sciences, Bergen", "University of Extremadura, Caceres, Spain",
    "Ohio State University, Columbus, USA", "Wayne State University, Detroit, USA",
    "Colorado State University, USA", "Polytechnic University of Milan, Italy", "TU Darmstadt",
    "Technical University of Graz, Austria", "INRIA, France", "ENS Paris, France",
    "Karlstad University, Sweden", "Purdue University, West Lafayette, USA",
    "University of Insubria, Varese, Italy", "University of Virginia, Charlottesville, USA", 
    "University of South Carolina, Columbia, SC, USA", "Yale University, New Haven, Connecticut, USA",
    "Florida Atlantic University, Boca Raton, Florida, USA", "TU Wien, Vienna, Austria", 
    "Sorbonne Universite, LIP6, Paris, France", "University Pierre and Marie Curie, Paris, France",
    "Georgetown University", "Carnegie Mellon University, Pittsburgh, USA", 
    "University of Texas at Arlington, USA", "University of Minho, Braga, Portugal", 
    "University of Calabria, Cosenza, Italy", "Binghamton University, Vestal, NY, USA", 
    "Princeton University, USA", "University of Padua, Italy", "University of Chicago",
    "University of Tampere, Finland"
]

with open(inputfile, "r", encoding="utf-8") as input:
    data = json.load(input)

for i in range(0, len(data)):
    for j in range(0, len(data[i]["authors"])):
        name = data[i]["authors"][j]["name"]

        if (random.random() <= emailp):
            emailname = (name.replace(" ", "")).lower()
            data[i]["authors"][j]["email"] = emailname + "@gmail.com"

        if (random.random() <= biop):
            u = random.randint(0, len(universities)-1)
            bio = name + " was born in " + str(random.randint(1940, 2000)) + " and studied at " + universities[u]
            data[i]["authors"][j]["bio"] = bio
            

with open(outputfile, "w", encoding="utf-8") as output:
    json.dump(data, output, indent=4)
