//Load www nodes
CALL apoc.load.xml("file:///dblp.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'www'] AS www_s
UNWIND www_s AS www
WITH www.key AS wwwKEY,
     www.mdate AS wwwMDATE,
     www.publtype AS wwwPUBLTYPE,
     www.reviewid AS wwwREVIEWID,
     www.rating AS wwwRATING,
     www.cdate AS wwwCDATE,
     [item in www._children WHERE item._type = "title"][0] AS title,
     [item in www._children WHERE item._type = "booktitle"][0] AS booktitle,
     [item in www._children WHERE item._type = "pages"][0] AS pages,
     [item in www._children WHERE item._type = "address"][0] AS address,
     [item in www._children WHERE item._type = "journal"][0] AS journal,
     [item in www._children WHERE item._type = "volume"][0] AS volume,
     [item in www._children WHERE item._type = "number"][0] AS number,
     [item in www._children WHERE item._type = "month"][0] AS month,
     [item in www._children WHERE item._type = "url"][0] AS url,
     [item in www._children WHERE item._type = "ee"][0] AS ee,
     [item in www._children WHERE item._type = "cdrom"][0] AS cdrom,
     [item in www._children WHERE item._type = "cite"][0] AS cite,
     [item in www._children WHERE item._type = "note"][0] AS note,
     [item in www._children WHERE item._type = "crossref"][0] AS crossref,
     [item in www._children WHERE item._type = "isbn"][0] AS isbn,
     [item in www._children WHERE item._type = "series"][0] AS series,
     [item in www._children WHERE item._type = "school"][0] AS school,
     [item in www._children WHERE item._type = "chapter"][0] AS chapter,
     [item in www._children WHERE item._type = "publnr"][0] AS publnr

MERGE (a:www {key: wwwKEY})
SET 
    a.mdate = wwwMDATE,
    a.publtype = wwwPUBLTYPE,
    a.reviewid = wwwREVIEWID,
    a.rating = wwwRATING,
    a.cdate = wwwCDATE,
    a.title = title._text,
    a.booktitle = booktitle._text,
    a.pages = pages._text,
    a.address = address._text,
    a.journal = journal._text,
    a.volume = volume._text,
    a.number = number._text,
    a.month = month._text,
    a.url = url._text,
    a.ee = ee._text,
    a.cdrom = cdrom._text,
    a.cite = cite._text,
    a.note = note._text,
    a.crossref = crossref._text,
    a.isbn = isbn._text,
    a.series = series._text,
    a.school = school._text,
    a.chapter = chapter._text,
    a.publnr = publnr._text
RETURN count(a);


//Load Author nodes
CALL apoc.load.xml("file:///dblp.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'www'] AS www_s
UNWIND www_s AS www
WITH www, [item in www._children WHERE item._type = "author"] AS author_s
UNWIND author_s AS author
MERGE (auth:Author {name:author._text})
RETURN count(auth);
// create relationships :WRITTEN_BY
CALL apoc.load.xml("file:///dblp.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'www'] AS www_s
UNWIND www_s AS www
WITH www.key AS wwwKEY, [item in www._children WHERE item._type = "author"] AS author_s
UNWIND author_s AS author
MATCH (a:www {key: wwwKEY})
MATCH (auth:Author {name:author._text})
MERGE (a)-[:WRITTEN_BY]->(auth)
RETURN *;

//Load Editor nodes
CALL apoc.load.xml("file:///dblp.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'www'] AS www_s
UNWIND www_s AS www
WITH www, [item in www._children WHERE item._type = "editor "] AS editor_s
UNWIND editor_s AS editor
MERGE (edit:Editor {name:editor._text})
RETURN count(edit);
// create relationships :EDIT_BY
CALL apoc.load.xml("file:///dblp.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'www'] AS www_s
UNWIND www_s AS www
WITH www.key AS wwwKEY, [item in www._children WHERE item._type = "editor "] AS editor_s
UNWIND editor_s AS editor
MATCH (a:www {key: wwwKEY})
MATCH (edit:Editor {name:editor._text})
MERGE (a)-[:EDIT_BY]->(edit)
RETURN *;

//Load Year nodes
CALL apoc.load.xml("file:///dblp.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'www'] AS www_s
UNWIND www_s AS www
WITH www, [item in www._children WHERE item._type = "year"][0] AS year
WHERE year IS NOT NULL
MERGE (y:Year {year:year._text})
RETURN count(y);
// create relationships :PUBLISHED_IN
CALL apoc.load.xml("file:///dblp.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'www'] AS www_s
UNWIND www_s AS www
WITH www.key AS wwwKEY, [item in www._children WHERE item._type = "year"][0] AS year
MATCH (a:www {key: wwwKEY})
MATCH (y:Year {year:year._text})
MERGE (a)-[:PUBLISHED_IN]->(y)
RETURN *;

//Load Publisher nodes
CALL apoc.load.xml("file:///dblp.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'www'] AS www_s
UNWIND www_s AS www
WITH www, [item in www._children WHERE item._type = "publisher"] AS publisher_s
UNWIND publisher_s AS publisher
MERGE (publ:Publisher {name:publisher._text})
RETURN count(publ);
// create relationships :PUBLISHED_BY
CALL apoc.load.xml("file:///dblp.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'www'] AS www_s
UNWIND www_s AS www
WITH www.key AS wwwKEY, [item in www._children WHERE item._type = "publisher"] AS publisher_s
UNWIND publisher_s AS publisher
MATCH (a:www {key: wwwKEY})
MATCH (publ:Publisher {name:publisher._text})
MERGE (a)-[:PUBLISHED_BY]->(publ)
RETURN *;

