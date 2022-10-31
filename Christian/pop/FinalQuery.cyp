
// 1. most cited author in a given field
// The following query can be used to find the authors, and their website if exists, who wrote about a given field (e.g. "data mining") ordering them by the sum of citations they received for thoose publications
MATCH (a:Person)-[:AUTHOR_OF]-(p:Publication)-[:ABOUT]->(k:Keyword {keyword: "data mining"})
OPTIONAL MATCH (w:Website)-[:HOMEPAGE_OF]-(a:Person)
WHERE p.citations IS NOT null
WITH w AS Website, a AS Author, SUM(p.citations) AS cit
ORDER BY cit DESC
RETURN Website, Author, cit
LIMIT 5

// 2. most active editor 
// Return people that organised (editor of) the most number of conferences (proceedings) held after 2010
MATCH (p:Person)-[:EDITOR_OF]-(c:Proceedings)-[:HELD_IN]->(y:Year)
WHERE y.year >= 2010
WITH p, COUNT(*) AS pcount
ORDER BY pcount DESC
RETURN p, pcount 
LIMIT 5


// 3.1 Top universities per number of phdthesit about a certain topic 
// Return the top 5 universities which have produced the higher number of phd thesis regarding the topic of data mining in the last seven years

MATCH (u:University)<-[r1:PRODUCED_BY]-(p1:Phdthesis)-[:ABOUT]->(:Keyword{keyword:"data mining"}), 
      (p1)-[:PUBLISHED_IN]->(y1:Year)
WHERE y1.year > 2012
WITH u, COUNT(r1) AS pcount
ORDER BY pcount DESC
RETURN u, pcount 
LIMIT 5

// 3.2 Top universities per number of publications about a certain topic 
// Return the top 5 universities which have produced the higher number of publications regarding the topic of data mining in the last seven years
MATCH (u:University)-[r2:AFFILIATED_TO]-(:Website)-[:HOMEPAGE_OF]-(a:Person),
      (a:Person)-[:AUTHOR_OF]-(p2:Publication)-[:ABOUT]->(:Keyword{keyword:"data mining"}),
      (p2)-[*1..2]->(y2:Year)
WHERE y2.year>2015
WITH u, COUNT(p2) AS pcount
ORDER BY pcount DESC
RETURN u, pcount 
LIMIT 5

// 4. Best professors by number of citations at a given university
// Return authors affiliated with Politecnico di Milano ordering them by the average number of citations across their publications
MATCH (u:University {name:"Polytechnic University of Milan, Italy"})<-[:AFFILIATED_TO]-(w:Website),
      (w:Website)-[:HOMEPAGE_OF]->(p:Person)-[]-(a:Publication)
WHERE a.citations IS NOT null
WITH p, avg(a.citations) AS avgcit
ORDER BY avgcit DESC
RETURN p, avgcit 


// 5. Top publisher by popularity of their works 
// Order publishers by the average number of citations of their works that were published after 2015
MATCH (p:Publisher)<-[:PUBLISHED_BY]-(a:publication)-[:PUBLISHED_IN]->(y:Year)
WHERE y.year >= 2015 AND a.citations IS NOT null
WITH p, avg(a.citations) AS avgcit
ORDER BY avgcit DESC
RETURN p, avgcit 
LIMIT 5


// 6. Most attended proceedings (conference) 
// Return the 5 proceedings held in the last 10 years with the highest number of authors who have contributed with a proceedings

MATCH (p:Proceedings)<-[c:CROSSREF]-(i:Inproceedings)<-[:AUTHOR_OF]-(a:Person),
      (y:Year)<-[h:HELD_IN]-(p:Proceedings)
WHERE y.year >= 2012
WITH y, p, COUNT(DISTINCT a) AS author_count
ORDER BY author_count DESC
RETURN y, p, author_count 
LIMIT 5


// 7.1 Top Journals for heterogeneity of topics
// Return the 5 journal (/series/proceedings) i cui articoli (/book/inproceedings) hanno il maggior numero di keyword distinte

MATCH (j:Journal)<-[:REFERS_TO]-(v:Volume)<-[:COLLECTED_IN]-(a:Article),
      (a:Article)-[:ABOUT]->(k:Keyword)
WITH j, COUNT(DISTINCT k) AS keywordcount
ORDER BY keywordcount DESC
RETURN j, keywordcount 
LIMIT 5

// 7.2 Top Journal by popularity of of their works 
// Order journals by the average number of citations of articles contained in it

MATCH (j:Journal)<-[:REFERS_TO]-(v:Volume)<-[:COLLECTED_IN]-(a:Article)
WHERE a.citations IS NOT null
WITH j, avg(a.citations) AS avgcit
ORDER BY avgcit DESC
RETURN j, avgcit 
LIMIT 10



// 8 Top series of book per topic
// Return the series that contain the most books about data mining published after 2018

MATCH (s:Series)-[:CONTAINS]->(b:Book)-[:ABOUT]->(k:Keyword {keyword: "data mining"}),
      (b:Book)-[:PUBLISHED_IN]->(y:Year)
WHERE y.year >= 2018
WITH s, COUNT(*) AS bookcount
ORDER BY bookcount DESC
RETURN s, bookcount 
LIMIT 5


// 9.1 Top publication about a certain topic written by a professor associated with a particular university
// Return publications about keyword:'data mining' written by professors associated with university:"Polytechnic University of Milan, Italy" , ordering them by the number of citations

MATCH (u:University{name:"SIGMOD Edgar F. Codd Innovations Award"})<-[:AFFILIATED_TO]-(w:Website)-[:HOMEPAGE_OF]->(a:Person),
      (a:Person)-[:AUTHOR_OF]->(p:Publication)-[:ABOUT]-(k:Keyword{keyword: "data mining"}),
      (w:Website)-[:HOMEPAGE_OF]->(a:Person)
WHERE p.citations IS NOT NULL
WITH p
ORDER BY p.citations DESC
RETURN p, p.citations 
Limit 5

// 9.2 
// Return publications about databases written after 2015 ordering them by the number of pages
MATCH (k:Keyword {keyword:"data mining"})<-[:ABOUT]-(p:Publication)-[:PUBLISHED_IN]->(y:Year)
WHERE y.year >=2010
WITH p
ORDER BY p.pages ASC
RETURN p, p.pages 
LIMIT 10

CALL{
    MATCH (k:Keyword {keyword:"data mining"})<-[:ABOUT]-(p:Publication)-[*1..2]->(y:Year)
    WHERE y.year >=2010
    WITH p
    ORDER BY p.pages ASC
    RETURN p, p.pages AS ppages
    LIMIT 10
}
WITH p, ppages
MATCH (a:Person)-[:AUTHOR_OF]-(p:Publication),
      (k:Keyword {keyword:"data mining"})<-[:ABOUT]-(p:Publication)
RETURN a,p,k, ppages


// 10.1
// Return the top 10 keywords used together with data mining 
MATCH (k:Keyword)<-[:ABOUT]-(p:Publication)-[:ABOUT]->(m:Keyword {keyword: "data mining"})
WITH k, COUNT(*) AS count
ORDER BY count DESC
RETURN k LIMIT 10

// Return the keywords that have the maximum number of citations across phdthesis published by university x

MATCH (u:University {name: "Stanford University, USA"})<-[:PRODUCED_BY]-(p:Phdthesis)-[:ABOUT]->(k:Keyword)
WHERE p.citations IS NOT null
WITH k, avg(p.citations) AS avgcit
ORDER BY avgcit DESC
RETURN k , avgcit 
LIMIT 10


// Return the top 10 keywords used in phdthesis published under university:"University of Erlangen-Nuremberg, Germany" after 2018

MATCH (u:University{name:"University of Erlangen-Nuremberg, Germany"})<-[:PRODUCED_BY]-(p:Phdthesis)-[:ABOUT]->(k:Keyword),
(p:Phdthesis)-[:PUBLISHED_IN]->(y:Year)
WHERE y.year > 2018 
WITH k, COUNT(*) AS kcount
ORDER BY kcount DESC
RETURN k, kcount LIMIT 10












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




// 3.2 Top universities per number of publications about a certain topic 
// Return the top 5 universities which have produced the higher number of publications regarding the topic of data mining in the last seven years
MATCH (u:University{name:"Polytechnic University of Milan, Italy"})-[r2:AFFILIATED_TO]-(:Website)-[:HOMEPAGE_OF]-(a:Person),
      (a:Person)-[:AUTHOR_OF]-(p2:Publication)-[:ABOUT]->(:Keyword{keyword:"data mining"}),
      (p2)-[*1..2]->(y2:Year)
WHERE y2.year>1990
WITH u, COUNT( DISTINCT p2) AS pcount
ORDER BY pcount DESC
RETURN u, pcount 
LIMIT 5


// 9.1 Top publication about a certain topic written by a professor associated with a particular university
// Return publications about keyword:'data mining' written by professors associated with university:"Polytechnic University of Milan, Italy" , ordering them by the number of citations

MATCH (u:University{name:"Polytechnic University of Milan, Italy"})<-[:AFFILIATED_TO]-(w:Website)-[:HOMEPAGE_OF]->(a:Person),
      (a:Person)-[:AUTHOR_OF]->(p:Publication)-[:ABOUT]-(k:Keyword{keyword: "data mining"}),
      (w:Website)-[:HOMEPAGE_OF]->(a:Person)
WHERE p.citations IS NOT NULL
WITH p
ORDER BY p.citations DESC
RETURN p, p.citations 
Limit 5


MATCH (u:University)-[r2:AFFILIATED_TO]-(w:Website)-[h:HOMEPAGE_OF]-(a:Person),
      (a:Person)-[ao:AUTHOR_OF]-(p2:Publication)-[ab:ABOUT]->(k:Keyword{keyword:"data mining"}),
      (p2)-[*1..2]->(y2:Year)
RETURN u, r2, w, h, a, ao, p2, ab, k
ORDER BY pcount DESC
RETURN u, pcount 
LIMIT 5

//

CALL{
    MATCH (u:University)-[:AFFILIATED_TO]-(w:Website)-[:HOMEPAGE_OF]-(a:Person),
        (a:Person)-[:AUTHOR_OF]-(p:Publication)-[:ABOUT]->(k:Keyword{keyword:"data mining"}),
        (p)-[*1..2]->(y:Year)
    WITH u, COUNT(DISTINCT p) AS pcount
    ORDER BY pcount DESC
    RETURN u, pcount 
    LIMIT 5
}
WITH u, pcount
MATCH (u:University)-[:AFFILIATED_TO]-(w:Website)-[:HOMEPAGE_OF]-(a:Person),
      (a:Person)-[:AUTHOR_OF]-(p:Publication)-[:ABOUT]->(k:Keyword{keyword:"data mining"}),
      (p)-[*1..2]->(y:Year)
RETURN u, w, a, p, k, pcount


//


// 9.1 Top publication about a certain topic written by a professor associated with a particular university
// Return publications about keyword:'data mining' written by professors associated with university:"Polytechnic University of Milan, Italy" , ordering them by the number of citations

MATCH (u:University{name:"SIGMOD Edgar F. Codd Innovations Award"})<-[:AFFILIATED_TO]-(w:Website)-[:HOMEPAGE_OF]->(a:Person),
      (a:Person)-[:AUTHOR_OF]->(p:Publication)-[:ABOUT]-(k:Keyword{keyword: "data mining"})
WHERE p.citations IS NOT NULL
WITH p
ORDER BY p.citations DESC
RETURN p, p.citations 
Limit 5


CALL{
    MATCH (u:University{name:"University of Arizona, Tucson, USA"})-[:AFFILIATED_TO]-(w:Website)-[:HOMEPAGE_OF]-(a:Person),
        (a:Person)-[:AUTHOR_OF]-(p:Publication)-[:ABOUT]->(k:Keyword{keyword:"data mining"})
    WHERE p.citations IS NOT NULL
    WITH p
    ORDER BY p.citations DESC
    RETURN p, p.citations AS pcit
    Limit 5
}
WITH p, pcit
     MATCH (u:University{name:"University of Arizona, Tucson, USA"})-[:AFFILIATED_TO]-(w:Website)-[:HOMEPAGE_OF]-(a:Person),
        (a:Person)-[:AUTHOR_OF]-(p:Publication)-[:ABOUT]->(k:Keyword{keyword:"data mining"})
RETURN u, w, a, p, k, pcit