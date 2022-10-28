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


//Dopo aver caricato i nodi proceedings: Load delle cross-ref tra inproceedings e proceedings

CALL apoc.load.xml("file:///inproceedings-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'inproceedings'] AS inproceedings_s
UNWIND inproceedings_s AS inproceedings
WITH inproceedings.key AS inproceedingsKEY,
     [item in inproceedings._children WHERE item._type = "crossref"] AS crossref_s
UNWIND crossref_s AS crossref
WITH inproceedingsKEY, crossref._text AS cross
MATCH (a:Inproceedings {key: inproceedingsKEY})
MATCH (p:Proceedings {key: cross})
MERGE (a)-[:CROSSREF]->(p)
RETURN count(*);

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

