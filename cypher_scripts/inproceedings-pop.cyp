//Load Inproceedings nodes
CALL apoc.load.xml("file:///inproceedings-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'inproceedings'] AS inproceedings_s
UNWIND inproceedings_s AS inproceedings
WITH inproceedings.key AS inproceedingsKEY,
     [item in inproceedings._children WHERE item._type = "title"][0] AS title,
     [item in inproceedings._children WHERE item._type = "note"] AS note_s,
     [item in inproceedings._children WHERE item._type = "ee"] AS ee_s,
     [item in inproceedings._children WHERE item._type = "cite"] AS cite_s
MERGE (p:Publication:Inproceedings {key: inproceedingsKEY})
SET 
    p.title = title._text,
    p.note = [note IN note_s | note._text],
    p.ee = [ee IN ee_s | ee._text],
    p.cite = [cite IN cite_s | cite._text]
RETURN count(p);



//Load Author nodes
CALL apoc.load.xml("file:///inproceedings-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'inproceedings'] AS inproceedings_s
UNWIND inproceedings_s AS inproceedings
WITH inproceedings,
     [item in inproceedings._children WHERE item._type = "author"] AS author_s
UNWIND author_s AS author
WITH author.orcid AS _orcid, author._text AS _name
MERGE (auth:Person {orcid:_orcid})
SET auth.name = _name
RETURN count(auth);
// create relationships :AUTHOR_OF
CALL apoc.load.xml("file:///inproceedings-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'inproceedings'] AS inproceedings_s
UNWIND inproceedings_s AS inproceedings
WITH inproceedings.key AS inproceedingsKEY,
     [item in inproceedings._children WHERE item._type = "author"] AS author_s
UNWIND author_s AS author
WITH inproceedingsKEY, author.orcid AS _orcid
MATCH (a:Inproceedings {key: inproceedingsKEY})
MATCH (auth:Person {orcid:_orcid})
MERGE (auth)-[:AUTHOR_OF]->(a)
RETURN count(*);


//Load Booktitle nodes
CALL apoc.load.xml("file:///inproceedings-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'inproceedings'] AS inproceedings_s
UNWIND inproceedings_s AS inproceedings
WITH [item in inproceedings._children WHERE item._type = "booktitle"][0] AS booktitle,
     [item in inproceedings._children WHERE item._type = "crossref"][0] AS crossref
MERGE (bt:Conference {name:booktitle._text})
SET bt.crossref = crossref._text
RETURN count(bt);
// create relationships : PRESENTED_AT
CALL apoc.load.xml("file:///inproceedings-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'inproceedings'] AS inproceedings_s
UNWIND inproceedings_s AS inproceedings
WITH inproceedings.key AS inproceedingsKEY, 
     [item in inproceedings._children WHERE item._type = "booktitle"][0] AS booktitle,
     [item in inproceedings._children WHERE item._type = "pages"][0] AS pages
MATCH (i:Inproceedings {key: inproceedingsKEY})
MATCH (bt:Conference {name:booktitle._text})
MERGE (i)-[r:PRESENTED_AT]->(bt)
SET r.pages = pages._text
RETURN count(r);


//Load years nodes
CALL apoc.load.xml("file:///inproceedings-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'inproceedings'] AS inproceedings_s
UNWIND inproceedings_s AS inproceedings
WITH [item in inproceedings._children WHERE item._type = "year"][0] AS year
MERGE (y:Year {year:toInteger(year._text)})
RETURN count(y);

// create relationships : PUBLISHED_IN
CALL apoc.load.xml("file:///inproceedings-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'inproceedings'] AS inproceedings_s
UNWIND inproceedings_s AS inproceedings
WITH inproceedings.key AS inproceedingsKEY, 
     [item in inproceedings._children WHERE item._type = "year"][0] AS year
MATCH (i:Inproceedings {key: inproceedingsKEY})
MATCH (y:Year {year:toInteger(year._text)})
MERGE (i)-[r:PUBLISHED_IN]->(y)
RETURN count(r);


// create relationships :CITES
CALL apoc.load.xml("file:///inproceedings-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'inproceedings'] AS inproceedings_s
UNWIND inproceedings_s AS inproceedings
WITH inproceedings.key AS inproceedingsKEY, 
     [item in inproceedings._children WHERE item._type = "cite"] AS cite_s
UNWIND cite_s AS cite
MATCH (a:Inproceedings {key: inproceedingsKEY})
MATCH (o:Publication {key: cite._text})
MERGE (a)-[r:CITES]->(o)
RETURN count(r);

