from random import random
import xml.etree.ElementTree as ET

#file di input e output (nella stessa directory del file python)
inputfile = "book-db-nokeywords.xml"
outputfile = "book-db.xml"

#list of keywords
keywords = ["data mining", "computer science", "python", "java", "javascript", "html", "c89", "c++", 
    "c#", "neo4j", "cypher", "mongodb", "big data", "unstructured data", "graph database", "ai",
    "machine learning", "deep learning", "q-learning", "graph search", "multiagent systems",
    "markov decision process", "graphs", "dijkstra", "software engineering", "software", "interfaces",
    "relational databases", "non-relational databases", "ER model", "graph model", "key-value databases",
    "redis", "algorithms", "path finding", "A*", "minimum path", "database design", "testing", 
    "debugging", "computer science engineering", "computer architectures", "cloud computing", 
    "language processing", "data processing"]

#probability to assign keywords
p = 0.8
#max number of keywords
maxkw = 10


with open(inputfile) as input:
    n = len(keywords)
    print("File opened")
    input_tree = ET.parse(inputfile)
    print("Input tree built")
    input_root = input_tree.getroot()

    for element in list(input_root):
        for i in range(0, maxkw):
            x = random()
            if(x <= 0.7):
                y = int(random() * n)
                if (y == n):
                    y = n-1
                kw = ET.SubElement(element, "keyword")
                kw.text = keywords[y]
            else:
                break

        

input_tree.write(outputfile)
print("Process ended")
