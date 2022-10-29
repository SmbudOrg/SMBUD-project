MATCH (n:Proceedings)-[r:HELD_IN]-()
RETURN n, count(r)
ORDER BY count(r) DESC

MATCH (n:Proceedings)-[r:PART_OF]-()
RETURN n, count(r)
ORDER BY count(r) DESC



MATCH (n:Incollection)-[r:COLLECTED_IN]-(m:Volume)
RETURN n, count(r)
ORDER BY count(r) DESC
LIMIT 10



MATCH (n:Phdthesis)-[r:PRODUCED_BY]-(m:University)
RETURN n, count(r)
ORDER BY count(r) DESC
LIMIT 10


MATCH (n:Article)-[r:COLLECTED_IN]-(m:Volume)
RETURN m, count(r)
ORDER BY count(r) DESC
LIMIT 5

MATCH (n:Volume)-[r:REFERS_TO]-(m:Journal)
RETURN m, count(r)
ORDER BY count(r) DESC
LIMIT 5

MATCH (n:Keyword)-[r]-()
RETURN n, count(r)
ORDER BY count(r) DESC




MATCH (n:Year) 
RETURN n 
ORDER BY id(n)


MATCH (n:Author)-[r]-()
RETURN n, count(r)
ORDER BY count(r)


// ARTICLE

//top autori
MATCH (n:Person)-[r:AUTHOR_OF]-(m:Article)
RETURN n, count(r)
ORDER BY count(r) DESC
LIMIT 5

//top Article per #Author
MATCH (n:Person)-[r:AUTHOR_OF]-(m:Article)
RETURN m, count(r)
ORDER BY count(r) DESC
LIMIT 5


// Get some data
MATCH (n:Author)-[r]->(m)
MATCH (n2:Publisher)-[]->()
MATCH (n3:Year)-[]->()
MATCH (n4:Article)-[]->()
MATCH (n5:Book)-[]->()
MATCH (n6:Inproceedings )-[]->()
MATCH (n7:Proceedings )-[]->()
MATCH (n8:Incollection )-[]->()
MATCH (n9:Phdthesis )-[]->()
MATCH (n10:Mastersthesis )-[]->()
MATCH (n11:Www)-[]->()
MATCH (n12:Person )-[]->()
MATCH (n13:Data )-[]->()

RETURN n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,n12,n13 LIMIT 300

// how 
MATCH (people:Person)-[relatedTo]-(:Movie {title: "Cloud Atlas"}) 
RETURN people.name, Type(relatedTo), relatedTo


// co-writer
MATCH (tom:Person {name:"Tom Hanks"})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActors) 
RETURN coActors.name


// Movies and actors up to 4 "hops" away from Kevin Bacon
MATCH (n1:Year)-[*1..4]-(n2)
RETURN DISTINCT n2 LIMIT 300

MATCH (n1:book)-[*1]-(n2)
RETURN DISTINCT n2 LIMIT 300



// BAcon-path,the shortest path of any relationships to Meg Ryan
MATCH p=shortestPath(
(bacon:Person {name:"Kevin Bacon"})-[*]-(meg:Person {name:"Meg Ryan"})
)
RETURN p