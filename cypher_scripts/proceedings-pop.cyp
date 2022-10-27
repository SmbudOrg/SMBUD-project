//Load Proceedings nodes
CALL apoc.load.xml("file:///proceedings-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'proceedings'] AS proceedings_s
UNWIND proceedings_s AS proceedings
WITH proceedings.key AS proceedingsKEY,
     [item in proceedings._children WHERE item._type = "title"][0] AS title,
     [item in proceedings._children WHERE item._type = "note"] AS note_s,
     [item in proceedings._children WHERE item._type = "ee"] AS ee_s
MERGE (p:Publication:Proceedings {key: proceedingsKEY})
SET 
    p.title = title._text,
    p.note = [note IN note_s | note._text],
    p.ee = [ee IN ee_s | ee._text]
RETURN count(p);


//Load editor nodes
CALL apoc.load.xml("file:///proceedings-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'proceedings'] AS proceedings_s
UNWIND proceedings_s AS proceedings
WITH [item in proceedings._children WHERE item._type = "editor"] AS editor_s
UNWIND editor_s AS editor
WITH editor.orcid AS _orcid, editor._text AS _name
MERGE (ed:Person {orcid:_orcid})
SET ed.name = _name
RETURN count(ed);
// create relationships :EDITOR_OF
CALL apoc.load.xml("file:///proceedings-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'proceedings'] AS proceedings_s
UNWIND proceedings_s AS proceedings
WITH proceedings.key AS proceedingsKEY, 
     [item in proceedings._children WHERE item._type = "editor"] AS editor_s
UNWIND editor_s AS editor
WITH  proceedingsKEY, editor.orcid AS _orcid
MATCH (p:Proceedings {key: proceedingsKEY})
MATCH (ed:Person {orcid:_orcid})
MERGE (ed)-[r:EDITOR_OF]->(p)
RETURN count(r);


//Load years nodes
CALL apoc.load.xml("file:///proceedings-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'proceedings'] AS proceedings_s
UNWIND proceedings_s AS proceedings
WITH [item in proceedings._children WHERE item._type = "year"][0] AS year
MERGE (y:Year {year:toInteger(year._text)})
RETURN count(y);
// create relationships : PUBLISHED_IN
CALL apoc.load.xml("file:///proceedings-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'proceedings'] AS proceedings_s
UNWIND proceedings_s AS proceedings
WITH proceedings.key AS proceedingsKEY, 
     [item in proceedings._children WHERE item._type = "year"][0] AS year
MATCH (p:Proceedings {key: proceedingsKEY})
MATCH (y:Year {year:toInteger(year._text)})
MERGE (p)-[r:PUBLISHED_IN]->(y)
RETURN count(r);


//Load publisher nodes
CALL apoc.load.xml("file:///proceedings-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'proceedings'] AS proceedings_s
UNWIND proceedings_s AS proceedings
WITH [item in proceedings._children WHERE item._type = "publisher"] AS publisher_s
UNWIND publisher_s AS publisher
MERGE (pu:Publisher {name:publisher._text})
RETURN count(pu);

// create relationships : PUBLISHED_BY
CALL apoc.load.xml("file:///proceedings-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'proceedings'] AS proceedings_s
UNWIND proceedings_s AS proceedings
WITH proceedings.key AS proceedingsKEY, 
     [item in proceedings._children WHERE item._type = "publisher"] AS publisher_s
UNWIND publisher_s AS publisher
MATCH (p:Proceedings {key: proceedingsKEY})
MATCH (pu:Publisher {name:publisher._text})
MERGE (p)-[r:PUBLISHED_BY]->(pu)
RETURN count(r);

//Load series nodes
CALL apoc.load.xml("file:///proceedings-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'proceedings'] AS proceedings_s
UNWIND proceedings_s AS proceedings
WITH [item in proceedings._children WHERE item._type = "series"] AS series_s
UNWIND series_s AS series
MERGE (se:Series {name:series._text})
RETURN count(se);

// create relationships : PART_OF
CALL apoc.load.xml("file:///proceedings-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'proceedings'] AS proceedings_s
UNWIND proceedings_s AS proceedings
WITH proceedings.key AS proceedingsKEY, 
     [item in proceedings._children WHERE item._type = "series"] AS series_s,
     [item in proceedings._children WHERE item._type = "volume"][0] AS volume,
     [item in proceedings._children WHERE item._type = "number"][0] AS number
UNWIND series_s AS series
MATCH (p:Proceedings {key: proceedingsKEY})
MATCH (se:Series {name:series._text})
MERGE (p)-[r:PART_OF]->(se)
SET r.number = number._text,
    r.volume = volume._text
RETURN count(r);