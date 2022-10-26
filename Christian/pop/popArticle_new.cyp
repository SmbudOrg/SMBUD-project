//Load article nodes
CALL apoc.load.xml("file:///article-volume.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'article'] AS article_s
UNWIND article_s AS article
WITH article.key AS articleKEY,
     article.mdate AS articleMDATE,
     [item in article._children WHERE item._type = "title"][0] AS title,
     [item in article._children WHERE item._type = "note"] AS note_s,
     [item in article._children WHERE item._type = "ee"] AS ee_s,
     [item in article._children WHERE item._type = "cite"] AS cite_s
MERGE (a:Article {key: articleKEY})
SET 
    a.mdate = articleMDATE,
    a.title = title._text,
    a.note = [note IN note_s | note._text],
    a.ee = [ee IN ee_s | ee._text],
    a.cite = [cite IN cite_s | cite._text]
RETURN count(a);


//Load Author nodes
CALL apoc.load.xml("file:///article-volume.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'article'] AS article_s
UNWIND article_s AS article
WITH [item in article._children WHERE item._type = "author"] AS author_s
UNWIND author_s AS author
MERGE (auth:Person {name:author._text})
SET auth.orcid = author.orcid
RETURN count(auth);
// create relationships :AUTHOR_OF
CALL apoc.load.xml("file:///article-volume.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'article'] AS article_s
UNWIND article_s AS article
WITH article.key AS articleKEY, 
     [item in article._children WHERE item._type = "author"] AS author_s
UNWIND author_s AS author
MATCH (a:Article {key: articleKEY})
MATCH (auth:Person {name:author._text})
MERGE (auth)-[r:AUTHOR_OF]->(a)
RETURN count(r);


//Load Volume, Journal nodes
CALL apoc.load.xml("file:///article-volume.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'article'] AS article_s
UNWIND article_s AS article
WITH article,
     [item in article._children WHERE item._type = "journal"][0] AS journal,
     [item in article._children WHERE item._type = "volume"][0] AS volume,
     [item in article._children WHERE item._type = "crossref"][0] AS crossref

MERGE (j:Journal {name: journal._text})
MERGE (v:Volume {journal: journal._text, volume: volume._text})
SET v.crossref = crossref._text
RETURN j,v;
// create relationships :COLLECTED_IN
CALL apoc.load.xml("file:///article-volume.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'article'] AS article_s
UNWIND article_s AS article
WITH article.key AS articleKEY,
     [item in article._children WHERE item._type = "journal"][0] AS journal,
     [item in article._children WHERE item._type = "volume"][0] AS volume,
     [item in article._children WHERE item._type = "number"][0] AS number,
     [item in article._children WHERE item._type = "pages"][0] AS pages

MATCH (a:Article {key: articleKEY})
MATCH (v:Volume {journal: journal._text, volume: volume._text})
MERGE (a)-[r:COLLECTED_IN]->(v)
SET r.number = number._text,
    r.pages = pages._text
RETURN DISTINCT count(r);
// create relationships :REFERS_TO
CALL apoc.load.xml("file:///article-volume.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'article'] AS article_s
UNWIND article_s AS article
WITH [item in article._children WHERE item._type = "journal"][0] AS journal,
     [item in article._children WHERE item._type = "volume"][0] AS volume
MATCH (v:Volume {journal: journal._text, volume: volume._text})
MATCH (j:Journal {name: journal._text})
MERGE (v)-[r:REFERS_TO]->(j)
RETURN DISTINCT count(r);


//Load Year nodes
CALL apoc.load.xml("file:///article-volume.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'article'] AS article_s
UNWIND article_s AS article
WITH [item in article._children WHERE item._type = "year"][0] AS year
WHERE year IS NOT NULL
MERGE (y:Year {year:year._text})
RETURN count(y);
// create relationships :PUBLISHED_IN
CALL apoc.load.xml("file:///article-volume.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'article'] AS article_s
UNWIND article_s AS article
WITH [item in article._children WHERE item._type = "volume"][0] AS volume, 
     [item in article._children WHERE item._type = "journal"][0] AS journal,
     [item in article._children WHERE item._type = "year"][0] AS year,
     [item in article._children WHERE item._type = "month"][0] AS month
MATCH (v:Volume {journal: journal._text, volume: volume._text})
MATCH (y:Year {year:year._text})
MERGE (v)-[r:PUBLISHED_IN]->(y)
SET r.month = month._text
RETURN count(r);


//Load Publisher nodes
CALL apoc.load.xml("file:///article-volume.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'article'] AS article_s
UNWIND article_s AS article
WITH [item in article._children WHERE item._type = "publisher"] AS publisher_s
UNWIND publisher_s AS publisher
MERGE (publ:Publisher {name:publisher._text})
RETURN count(publ);
// create relationships :PUBLISHED_BY
CALL apoc.load.xml("file:///article-volume.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'article'] AS article_s
UNWIND article_s AS article
WITH [item in article._children WHERE item._type = "volume"][0] AS volume, 
     [item in article._children WHERE item._type = "journal"][0] AS journal,
     [item in article._children WHERE item._type = "publisher"] AS publisher_s
UNWIND publisher_s AS publisher
MATCH (v:Volume {journal: journal._text, volume: volume._text})
MATCH (publ:Publisher {name:publisher._text})
MERGE (v)-[r:PUBLISHED_BY]->(publ)
RETURN count(r);





// create relationships :CITES
CALL apoc.load.xml("file:///article-volume.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'article'] AS article_s
UNWIND article_s AS article
WITH article.key AS articleKEY, 
     [item in article._children WHERE item._type = "cite"] AS cite_s
UNWIND cite_s AS cite
MATCH (a:Article {key: articleKEY})
MATCH (o {key: cite._text})
MERGE (a)-[r:CITES]->(o)
RETURN (a)-[r]-(o);





