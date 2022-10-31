CALL{

}
WITH
MATCH 
RETURN
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

CALL{
    MATCH (p:Person)-[:EDITOR_OF]-(c:Proceedings)-[:HELD_IN]->(y:Year)
    WHERE y.year >= 2010
    WITH p, COUNT(*) AS pcount
    ORDER BY pcount DESC
    RETURN p, pcount 
    LIMIT 5
}
WITH p, pcount
MATCH (p:Person)-[:EDITOR_OF]-(c:Proceedings)
RETURN p,c

// 3.1 Top universities per number of phdthesit about a certain topic 
// Return the top 5 universities which have produced the higher number of phd thesis regarding the topic of data mining in the last seven years

MATCH (u:University)<-[:PRODUCED_BY]-(p:Phdthesis)-[:ABOUT]->(k:Keyword{keyword:"data mining"}), 
      (p)-[:PUBLISHED_IN]->(y:Year)
WHERE y.year > 2012
WITH u, COUNT(DISTINCT p) AS pcount
ORDER BY pcount DESC
RETURN u, pcount 
LIMIT 5

CALL{
    MATCH (u:University)<-[:PRODUCED_BY]-(p:Phdthesis)-[:ABOUT]->(k:Keyword), 
          (p)-[:PUBLISHED_IN]->(y:Year)
    WHERE y.year > 2012 AND k.keyword = "data mining"
    WITH u, COUNT(DISTINCT p) AS pcount
    ORDER BY pcount DESC
    RETURN u, pcount 
    LIMIT 5
}
WITH u, pcount
MATCH (u:University)<-[:PRODUCED_BY]-(p:Phdthesis)-[:ABOUT]->(k:Keyword), 
      (p)-[:PUBLISHED_IN]->(y:Year)
WHERE y.year > 2012 AND k.keyword = "data mining"
RETURN u, p, k, pcount


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
MATCH (p:Publisher)<-[:PUBLISHED_BY]-(a:Publication)-[:PUBLISHED_IN]->(y:Year)
WHERE y.year >= 2015 AND a.citations IS NOT null
WITH p, avg(a.citations) AS avgcit
ORDER BY avgcit DESC
RETURN p.name, avgcit 
LIMIT 5


// 6. Most attended proceedings (conference) 
// Return the 5 proceedings held in the last 10 years with the highest number of authors who have contributed with a proceedings

MATCH (p:Proceedings)<-[c:CROSSREF]-(i:Inproceedings)<-[:AUTHOR_OF]-(a:Person),
      (y:Year)<-[h:HELD_IN]-(p:Proceedings)
WHERE y.year >= 2012
WITH y, p, COUNT(DISTINCT a) AS author_count
ORDER BY author_count DESC
RETURN y, p.title, author_count 
LIMIT 5


// 7.1 Top Journals for heterogeneity of topics
// Return the 5 journal (/series/proceedings) i cui articoli (/book/inproceedings) hanno il maggior numero di keyword distinte

MATCH (j:Journal)<-[:REFERS_TO]-(v:Volume)<-[:COLLECTED_IN]-(a:Article),
      (a:Article)-[:ABOUT]->(k:Keyword)
WITH j, COUNT(DISTINCT k) AS keywordcount
ORDER BY keywordcount DESC
RETURN j, keywordcount 
LIMIT 10

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

CALL{
    MATCH (s:Series)-[:CONTAINS]->(b:Book)-[:ABOUT]->(k:Keyword {keyword: "data mining"}),
        (b:Book)-[:PUBLISHED_IN]->(y:Year)
    WHERE y.year >= 2018
    WITH s, COUNT(*) AS bookcount
    ORDER BY bookcount DESC
    RETURN s, bookcount 
    LIMIT 5
}
WITH s, bookcount
MATCH (s:Series)-[:CONTAINS]->(b:Book)-[:ABOUT]->(k:Keyword {keyword: "data mining"}),
      (b:Book)-[:PUBLISHED_IN]->(y:Year)
WHERE y.year >= 2018
RETURN s, b, k


// 9.1 Top publication about a certain topic written by a professor associated with a particular university
// Return publications about keyword:'data mining' written by professors associated with university:"Polytechnic University of Milan, Italy" , ordering them by the number of citations

MATCH (u:University{name:"University of Trier, Germany"})<-[:AFFILIATED_TO]-(w:Website)-[:HOMEPAGE_OF]->(a:Person),
      (a:Person)-[:AUTHOR_OF]->(p:Publication)-[:ABOUT]-(k:Keyword{keyword: "data mining"}),
      (w:Website)-[:HOMEPAGE_OF]->(a:Person)
WHERE p.citations IS NOT NULL
WITH p
ORDER BY p.citations DESC
RETURN p, p.citations 
Limit 5

CALL{
    MATCH (u:University)-[:AFFILIATED_TO]-(w:Website)-[:HOMEPAGE_OF]-(a:Person),
          (a:Person)-[:AUTHOR_OF]-(p:Publication)-[:ABOUT]->(k:Keyword{keyword:"data mining"})
    WHERE p.citations IS NOT NULL AND u.name = 'University of Arizona, Tucson, USA' 
    WITH p
    ORDER BY p.citations DESC
    RETURN p, p.citations AS pcit
    Limit 5
}
WITH p, pcit
MATCH (u:University)-[:AFFILIATED_TO]-(w:Website)-[:HOMEPAGE_OF]-(a:Person),
      (a:Person)-[:AUTHOR_OF]-(p:Publication)-[:ABOUT]->(k:Keyword{keyword:"data mining"})
WHERE p.citations IS NOT NULL AND u.name = 'University of Arizona, Tucson, USA' 
RETURN u, w, a, p, k, pcit

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
      (k:Keyword {keyword:"data mining"})<-[:ABOUT]-(p:Publication)-[*1..2]->(y:Year)
WHERE y.year >=2010
RETURN a,p,k, ppages


// 10.1
// Return the top 10 keywords used together with data mining 
MATCH (k:Keyword)<-[:ABOUT]-(p:Publication)-[:ABOUT]->(m:Keyword {keyword: "data mining"})
WITH k, COUNT(k) AS count
ORDER BY count DESC
RETURN k, count 
LIMIT 10

// Return the keywords that have the maximum number of citations across phdthesis published by university x

MATCH (u:University {name: "Stanford University, USA"})<-[:PRODUCED_BY]-(p:Phdthesis)-[:ABOUT]->(k:Keyword)
WHERE p.citations IS NOT null
WITH k, avg(p.citations) AS avgcit
ORDER BY avgcit DESC
RETURN k , avgcit 
LIMIT 10


// Return the top 10 keywords used in phdthesis published under university:"University of Erlangen-Nuremberg, Germany" after 2018

MATCH (u:University)<-[:PRODUCED_BY]-(p:Phdthesis)-[:ABOUT]->(k:Keyword),
(p:Phdthesis)-[:PUBLISHED_IN]->(y:Year)
WHERE y.year > 2015 AND u.name = "University of Erlangen-Nuremberg, Germany"
WITH k, COUNT(*) AS kcount
ORDER BY kcount DESC
RETURN k, kcount 
LIMIT 5

//--------------------------------



// 11
// Return the minimum path between two keywords through keywords that appear in a publication together


MATCH (a:Person{name:"Hector Garcia-Molina"}), (b:Person{name: "Philip S. Yu"}),
      p = SHORTESTPATH((a)-[*]-(b))
WHERE all(r IN relationships(p) WHERE type(r) = 'AUTHOR_OF')
RETURN p



//-----------------------------------------------------

// 1. Add the "machine learning" keyword to books in the "Intelligent Systems Reference Library" series from volume 85 to volume 100

MATCH (s:Series)-[r:CONTAINS]-(b:Book)
WHERE r.volume IS NOT NULL AND r.volume >= 85 AND r.volume <= 100
MERGE (k:Keyword {keyword: "machine learning"})
MERGE((b)-[t:ABOUT]->(k))
RETURN s, b, t, k

2. Insert a new Phdthesis

MERGE(p:Publication:Phdthesis{key: "newphdthesiskey"})
SET p.title = "New Phd Thesis",
p.pages = 54,
p.citations = 0
MERGE(a:Person {orcid: "Barbara Hausmann"})
SET a.name = "Barbara Hausmann"
MERGE((a)-[r:AUTHOR_OF]-(p))
MERGE(y:Year {year: 2022})
MERGE((p)-[:PUBLISHED_IN]->(y))
MERGE(pub:Publisher {name: "Springer"})
MERGE((p)-[:PUBLISHED_BY]->(pub))
RETURN p, a, y, pub

3. Insert a website for Barbara Hausmann, affiliating her to the Technical University of Graz, Austria

MATCH(a:Person {orcid: "Barbara Hausmann"})
MERGE(w:Website {key: "newwebsitekey"})
SET w.title = "Barbara Hausmann's homepage",
    w.url = "www.barbarahausmann.com"
MERGE((w)-[:HOMEPAGE_OF]->(a))
MERGE(u:University {name: "Technical University of Graz, Austria"})
MERGE((w)-[:AFFILIATED_TO]->(u))
RETURN a, w, u

4. Add a new inproceedings to the proceedings of "26th IEEE International Conference on Parallel and Distributed Systems, ICPADS 2020, Hong Kong, December 2-4, 2020", which has key "conf/icpads/2020", and add keyword "distributed systems"

MATCH(p:Proceedings {key: "conf/icpads/2020"})
MERGE(i:Publication:Inproceedings {key: "newinprockey"})
SET i.title = "New article about Distributed Systems",
    i.pages = 36,
    i.citations = 15
MERGE((i)-[:CROSSREF]->(p))
MERGE(k:Keyword {keyword: "distributed systems"})
MERGE((i)-[:ABOUT]->(k))
RETURN p, i, k

5. Add a new article to volume 51 of journal "Commun. ACM". The volume was published in 2022.

MATCH (j:Journal {name: "Commun. ACM"})
MERGE (v:Volume {journal: "Commun. ACM", volume: 51})
MERGE ((v)-[:REFERS_TO]->(j))
MATCH ((v)-[r:PUBLISHED_IN]->(z:Year))
WHERE z.year <> 2022
DELETE r
MERGE(y:Year {year: 2022})
MERGE ((v)-[:PUBLISHED_IN]->(y))
MERGE (a:Publication:Article {key: "newarticlekey"})
SET a.title = "New Article",
    a.pages = 112
MERGE ((a)-[:COLLECTED_IN]->(v))
RETURN j, v, a, y





MERGE (a:Publication:Article {key: "newarticlekey"})
SET a.title = "New Article",
    a.pages = 112
MERGE (j:Journal {name: "Commun. ACM"})
MERGE (v:Volume {journal: "Commun. ACM", volume: 51})
MATCH (a:Publication:Article {key: "newarticlekey"}),
      (j:Journal {name: "Commun. ACM"}),
      (v:Volume {journal: "Commun. ACM", volume: 51})
MERGE ((a)-[:COLLECTED_IN]->(v)-[:REFERS_TO]->(j))
RETURN j, v, a

MERGE (a:Publication:Article {key: "newarticlekey"})
SET a.title = "New Article",
    a.pages = 112
MERGE (j:Journal {name: "Commun. ACM"})
MERGE (v:Volume {journal: "Commun. ACM", volume: 51})
WITH j, v, a
MERGE ((a)-[:COLLECTED_IN]->(v)-[:REFERS_TO]->(j))
RETURN j, v, a