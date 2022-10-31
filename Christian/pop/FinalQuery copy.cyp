
// 1. most influential author in a given field
// The following query can be used to find the authors, and their website if exists, who wrote about a given field (e.g. "data mining") ordering them by the sum of citations they received for thoose publications
MATCH (a:Person)-[:AUTHOR_OF]-(p:Publication)-[:ABOUT]->(k:Keyword {keyword: "data mining"})
OPTIONAL MATCH (w:Website)-[:HOMEPAGE_OF]-(a:Person)
WHERE p.citations IS NOT null
WITH w AS Website, a AS Author, SUM(p.citations) AS cit
ORDER BY cit DESC
RETURN Website, Author, cit
LIMIT 10


// 2. most active editor in the last 10 years 
// Return people that organised (editor of) the most number of conferences (proceedings) held after 2010
MATCH (p:Person)-[:EDITOR_OF]-(c:Proceedings)-[:HELD_IN]->(y:Year)
WHERE y.year >= 2010
WITH p, COUNT(*) AS pcount
ORDER BY pcount DESC
RETURN p, pcount LIMIT 10


// Return the top 10 universities which have produced the higher number of phd thesis regarding the topic of data mining in the last two years
// (il dataset include le pubblicazioni fino al 2021 o 2022?)

MATCH (u:University)<-[:PRODUCED_BY]-(p:Phedthesis)-[r:ABOUT]->(k:Keyword{keyword:"machine learning"})
MATCH (p)-[:PUBLISHED_IN]->(y:Year)
WHERE y.year>2000
RETURN u, count(r) AS n_thesis
ORDER BY n_thesis DESC
LIMIT 10





//-----------------------------------------------------------------------------------

// return AUTHOR (author of a publication, so: Article|Phdthesis|Inproceedings|Incollection|Book)

// Return top 10 authors that have written the most about data mining, but only the ones who have a website
// (4 nodes, aggregation, function)

MATCH (w:Website)-[:HOMEPAGE_OF]-(a:Person)-[:AUTHOR_OF]-(p:Publication)-[:ABOUT]->(k:Keyword {keyword: "data mining"})
WITH w, a, COUNT(*) AS pubcount
ORDER BY pubcount DESC
RETURN w, a, pubcount
LIMIT 10


// Return authors that wrote about data mining ordering them by the sum of the number of citations their articles about data mining received

MATCH (p:Person)-[:AUTHOR_OF]->(a:Article)-[:ABOUT]->(k:Keyword {keyword: "data mining"})
WHERE a.citations IS NOT null
WITH p, SUM(a.citations) AS cit
ORDER BY cit DESC
RETURN p, cit 
LIMIT 10


// most influential author in a given field
// return autohrs wich wrote about a given field 
MATCH (w:Website)-[:HOMEPAGE_OF]-(a:Person)-[:AUTHOR_OF]-(p:Publication)-[:ABOUT]->(k:Keyword {keyword: "data mining"})
WHERE p.citations IS NOT null
WITH w, a, SUM(p.citations) AS cit
ORDER BY cit DESC
RETURN w, a, cit
LIMIT 10



// Return the author with the maximum number of citations across publications about data mining and their website

MATCH (w:Website)-[:HOMEPAGE_OF]->(a:Person)-[:AUTHOR_OF]->(p:Publication)-[:ABOUT]->(k:Keyword {keyword: "data mining"})
WHERE p.citations IS NOT null
WITH w, a, SUM(p.citations) AS sumcit
ORDER BY sumcit DESC
RETURN w, a LIMIT 1



// Return authors affiliated with Politecnico di Milano ordering them by the average number of citations across their publications

MATCH (u:University {name:"Polytechnic University of Milan, Italy"})<-[:AFFILIATED_TO]-(w:Website)-[:HOMEPAGE_OF]->(p:Person)-[]-(a:Publication)
WHERE a.citations IS NOT null
WITH p, avg(a.citations) AS avgcit
ORDER BY avgcit DESC
RETURN p 


//-----------------------------------------------------------------------------------



// return  EDITOR

// Return people that organised (editor of) the most number of conferences (proceedings) held after 2010

MATCH (p:Person)-[]-(c:Proceedings)-[:HELD_IN]->(y:Year)
WHERE y.year >= 2010
WITH p, COUNT(*) AS pcount
ORDER BY pcount DESC
RETURN p, pcount LIMIT 10

//-----------------------------------------------------------------------------------


// return  PROCEEDINGS

// Return the 5 proceedings containing the biggest number of inproceedings for each of the last 10 years

MATCH (y:Year)<-[h:HELD_IN]-(p:Proceedings)<-[c:CROSSREF]-(i:Inproceedings)
WHERE y.year >= 2012
WITH y, p, COUNT(*) AS inproceedings_count
ORDER BY inproceedings_count DESC
RETURN y, p, inproceedings_count LIMIT 5
//-----------------------------------------------------------------------------------





// return  PUBLISHER

// Order publishers by the average number of citations of their works that were published after 2015

MATCH (p:Publisher)<-[:PUBLISHED_BY]-(a:Publication)-[:PUBLISHED_IN]->(y:Year)
WHERE y.year >= 2015 AND a.citations IS NOT null
WITH p, avg(a.citations) AS avgcit
ORDER BY avgcit DESC
RETURN p, avgcit 
LIMIT 10
//-----------------------------------------------------------------------------------





// return  UNIVERSITY 

// Return the university with the most phd thesis about data mining

MATCH (u:University)<-[:PRODUCED_BY]-(p:Phdthesis)-[:ABOUT]->(k:Keyword {keyword: "data mining"})
WITH u, COUNT(*) AS pcount
ORDER BY pcount DESC
RETURN u, pcount 
LIMIT 1

// Return the top 10 universities which have produced the higher number of phd thesis regarding the topic of data mining in the last two years
// (il dataset include le pubblicazioni fino al 2021 o 2022?)

MATCH (u:University)<-[:PRODUCED_BY]-(p:Phedthesis)-[r:ABOUT]->(k:Keyword{keyword:"data mining"})
MATCH (p)-[:PUBLISHED_IN]->(y:Year)
WHERE y.year>2000
RETURN u, count(r) AS n_thesis
ORDER BY n_thesis DESC
LIMIT 10

//-----------------------------------------------------------------------------------




// return PUBLICATION 

// Return publications about keyword:'data mining' written by professors associated with university:"Polytechnic University of Milan, Italy" , ordering them by the number of citations
// (5 nodes)

MATCH (u:University)<-[:AFFILIATED_TO]-(w:Website)-[:HOMEPAGE_OF]->(a:Person)-[:AUTHOR_OF]->(p:Publication)-[:ABOUT]-(k:Keyword)
WHERE k.keyword = "data mining" AND u.name = "Polytechnic University of Milan, Italy" AND p.citations IS NOT NULL
WITH p
ORDER BY p.citations DESC
RETURN p, p.citations 
Limit 10

// Return publications about databases written after 2015 ordering them by the number of pages

MATCH (k:Keyword {keyword:"neo4j"})<-[:ABOUT]-(p:Publication)-[:PUBLISHED_IN]->(y:Year)
WHERE y.year >=2010
WITH p
ORDER BY p.pages ASC
RETURN p, p.pages 
LIMIT 10

//-----------------------------------------------------------------------------------


// return JOURNAL

// Ritornare i journal (/series/proceedings) i cui articoli (/book/inproceedings) hanno il maggior numero di keyword distinte
// (I journal che scrivono di argomenti più eterogenei)

MATCH (j:Journal)<-[:REFERS_TO]-(v:Volume)<-[:COLLECTED_IN]-(a:Article)-[:ABOUT]->(k:Keyword)
WITH j, COUNT(DISTINCT k) AS keywordcount
ORDER BY keywordcount DESC
RETURN j, keywordcount 
LIMIT 10

// Order journals by the average number of citations of articles contained in it

MATCH (j:Journal)<-[:REFERS_TO]-(v:Volume)<-[:COLLECTED_IN]-(a:Article)
WHERE a.citations IS NOT null
WITH j, avg(a.citations) AS avgcit
ORDER BY avgcit DESC
RETURN j, avgcit 
LIMIT 10

//-----------------------------------------------------------------------------------


// return SERIES of book

// Return the series that contain the most books about data mining published after 2018
// (5 nodes, aggregation, functions)

MATCH (s:Series)-[:CONTAINS]->(b:Book)-[:ABOUT]->(k:Keyword {keyword: "data mining"}),
      (b:Book)-[:PUBLISHED_IN]->(y:Year)
WHERE y.year >= 2018
WITH s, COUNT(*) AS bookcount
ORDER BY bookcount DESC
RETURN s, bookcount 
LIMIT 5

//-----------------------------------------------------------------------------------

//return KEYWORD

// Return the top 10 keywords used together with data mining 
// (3 nodes, aggregations, functions)
MATCH (k:Keyword)<-[:ABOUT]-(p:Publication)-[:ABOUT]->(m:Keyword {keyword: "data mining"})
WITH k, COUNT(*) AS count
ORDER BY count DESC
RETURN k LIMIT 10

// Return the top 10 keywords used in phdthesis published under university:"University of Erlangen-Nuremberg, Germany" after 2018

MATCH (u:University{name:"University of Erlangen-Nuremberg, Germany"})<-[:PRODUCED_BY]-(p:Phdthesis)-[:ABOUT]->(k:Keyword),
(p:Phdthesis)-[:PUBLISHED_IN]->(y:Year)
WHERE y.year > 2018 
WITH k, COUNT(*) AS kcount
ORDER BY kcount DESC
RETURN k, kcount LIMIT 10


// Return the keywords that have the maximum number of citations across phdthesis published by university x

MATCH (u:University {name: "Stanford University, USA"})<-[:PRODUCED_BY]-(p:Phdthesis)-[:ABOUT]->(k:Keyword)
WHERE p.citations IS NOT null
WITH k, avg(p.citations) AS avgcit
ORDER BY avgcit DESC
RETURN k , avgcit 
LIMIT 10


//-----------------------------------------------------------------------------------






// Return the minimum path between two keywords through keywords that appear in a publication together

MATCH (a:Keyword {keyword: "ER model"}), (b:Keyword {keyword:"machine learning"}),
p = SHORTESTPATH((a)-[:ABOUT*]-(b))
RETURN p




// Return website of an editor who has edited at least one book and one proceeding published by the same Publisher (IEEE for example)

MATCH (w:Website)-[:HOMEPAGE_OF]->(pe1:Person)-[:EDITOR_OF]->(pr:Proceedings)-[:PUBLISHED_BY]->(pu:Publisher)<-[PUBLISHED_BY]-(b:Book)<-[:EDITOR_OF]-(pe2:Person)
WHERE pe1 = pe2 AND pu.publisher = 'IEEE'
RETURN DISTINCT w


// 
MATCH p = SHORTESTPATH((a:Keyword {keyword: "ER model"})-[:ABOUT*]-(b:Keyword {keyword:"machine learning"})) 
WHERE all(a in nodes(p) WHERE a:Article OR a:Keyword)
RETURN p


