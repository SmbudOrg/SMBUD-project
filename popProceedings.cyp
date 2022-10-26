//Load Proceedings nodes

CALL apoc.load.xml("file:///proceedings_filtered.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'proceedings'] AS proceedings_s
UNWIND proceedings_s AS proceedings
WITH proceedings.key AS proceedingsKEY,
     proceedings.mdate AS proceedingsMDATE,
     [item in proceedings._children WHERE item._type = "title"][0] AS title,
     [item in proceedings._children WHERE item._type = "note"] AS note_s,
     [item in proceedings._children WHERE item._type = "ee"] AS ee_s,
MERGE (p:proceedings {key: proceedingsKEY})
SET 
    p.mdate = proceedingsMDATE,
    p.title = title._text,
    p.note = [note IN note_s | note._text],
    p.ee = [ee IN ee_s | ee._text],
RETURN count(p);

//Load editor nodes

CALL apoc.load.xml("file:///proceedings_filtered.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'proceedings'] AS proceedings_s
UNWIND proceedings_s AS proceedings
WITH [item in proceedings._children WHERE item._type = "editor"] AS editor_s
UNWIND editor_s AS editor
MERGE (ed:editor {name:editor._text})
SET ed.orcid = editor.orcid
RETURN count(ed);

// create relationships :editor_OF

CALL apoc.load.xml("file:///proceedings_filtered.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'proceedings'] AS proceedings_s
UNWIND proceedings_s AS proceedings
WITH proceedings.key AS proceedingsKEY, 
     [item in proceedings._children WHERE item._type = "editor"] AS editor_s
UNWIND editor_s AS editor
MATCH (p:proceedings {key: proceedingsKEY})
MATCH (ed:editor {name:editor._text})
MERGE (ed)-[r:year_OF]->(p)
RETURN count(r);

//Load years nodes

CALL apoc.load.xml("file:///proceedings_filtered.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'proceedings'] AS proceedings_s
UNWIND proceedings_s AS proceedings
WITH [item in proceedings._children WHERE item._type = "year"] AS year_s
UNWIND year_s AS year
MERGE (y:year {year_number:year._text})
RETURN count(y);

// create relationships : PUBLISHED_IN

CALL apoc.load.xml("file:///proceedings_filtered.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'proceedings'] AS proceedings_s
UNWIND proceedings_s AS proceedings
WITH proceedings.key AS proceedingsKEY, 
     [item in proceedings._children WHERE item._type = "year"] AS year_s
UNWIND year_s AS year
MATCH (p:proceedings {key: proceedingsKEY})
MATCH (y:year {year_number:year._text})
MERGE (p)-[r:PUBLISHED_IN]->(y)
RETURN count(r);

//Load publisher nodes

CALL apoc.load.xml("file:///proceedings_filtered.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'proceedings'] AS proceedings_s
UNWIND proceedings_s AS proceedings
WITH [item in proceedings._children WHERE item._type = "publisher"] AS publisher_s
UNWIND publisher_s AS publisher
MERGE (pu:publisher {publisher_name:publisher._text})
RETURN count(pu);

// create relationships : PUBLISHED_BY

CALL apoc.load.xml("file:///proceedings_filtered.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'proceedings'] AS proceedings_s
UNWIND proceedings_s AS proceedings
WITH proceedings.key AS proceedingsKEY, 
     [item in proceedings._children WHERE item._type = "publisher"] AS publisher_s
UNWIND publisher_s AS publisher
MATCH (p:proceedings {key: proceedingsKEY})
MATCH (pu:publisher {publisher_name:publisher._text})
MERGE (p)-[r:PUBLISHED_BY]->(pu)
RETURN count(r);

//Load series nodes

CALL apoc.load.xml("file:///proceedings_filtered.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'proceedings'] AS proceedings_s
UNWIND proceedings_s AS proceedings
WITH [item in proceedings._children WHERE item._type = "series"] AS series_s
UNWIND series_s AS series
MERGE (se:series {series_name:series._text})
RETURN count(se);

// create relationships : PART_OF

CALL apoc.load.xml("file:///proceedings_filtered.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'proceedings'] AS proceedings_s
UNWIND proceedings_s AS proceedings
WITH proceedings.key AS proceedingsKEY, 
     [item in proceedings._children WHERE item._type = "series"] AS series_s
UNWIND series_s AS series
MATCH (p:proceedings {key: proceedingsKEY})
MATCH (se:series {series_name:series._text})
MERGE (p)-[r:PART_OF]->(se)
RETURN count(r);