MATCH (n:Proceedings)-[r:HELD_IN]-()
RETURN n, count(r)
ORDER BY count(r) DESC

MATCH (n:Proceedings)-[r:PART_OF]-()
RETURN n, count(r)
ORDER BY count(r) DESC



MATCH (n:Year) 
RETURN n 
ORDER BY id(n)


MATCH (n:Author)-[r]-()
RETURN n, count(r)
ORDER BY count(r)



// Get some data
MATCH (n:Author)-[r]->(m)
MATCH (n2:Publisher)-[]->()
MATCH (n3:Year)-[]->()
MATCH (n4:article)-[]->()
MATCH (n5:book)-[]->()
MATCH (n6:inproceedings )-[]->()
MATCH (n7:proceedings )-[]->()
MATCH (n8:incollection )-[]->()
MATCH (n9:phdthesis )-[]->()
MATCH (n10:mastersthesis )-[]->()
MATCH (n11:www)-[]->()
MATCH (n12:person )-[]->()
MATCH (n13:data )-[]->()

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