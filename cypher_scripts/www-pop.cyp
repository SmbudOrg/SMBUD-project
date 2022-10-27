
//Load dei www
CALL apoc.load.xml("https://raw.githubusercontent.com/SmbudOrg/SMBUD-project/main/databases/www-db.xml?token=GHSAT0AAAAAAB2IKUGEBT7LTPXPFJFUIKE2Y22URVQ") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'www'] AS www_s
UNWIND www_s AS www
WITH www.key AS wwwKEY,
     [item in www._children WHERE item._type = "author"][0] AS author,
     [item in www._children WHERE item._type = "title"][0] AS title,
     [item in www._children WHERE item._type = "url"] AS urls,
     [item in www._children WHERE item._type = "note"] AS notes //note non va messo in realtà
MERGE (a:www {key: wwwKEY})
SET 
    a.title = title._text,
    a.url = [url IN urls | url._text],
    a.note = [note IN notes | note._text]
RETURN count(a);

//A partire da www genera autori e fai collegamenti
CALL apoc.load.xml("file:///d-www.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'www'] AS www_s
UNWIND www_s AS www
WITH www, [item in www._children WHERE item._type = "author"] AS author_s
UNWIND author_s AS author
MERGE (auth:Author {name:author._text})
RETURN count(auth);
// create relationships :HOMEPAGE_OF
CALL apoc.load.xml("file:///d-www.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'www'] AS www_s
UNWIND www_s AS www
WITH www.key AS wwwKEY, [item in www._children WHERE item._type = "author"] AS author_s
UNWIND author_s AS author
MATCH (a:www {key: wwwKEY})
MATCH (auth:Author {name:author._text})
MERGE (a)-[:HOMEPAGE_OF]->(auth)
RETURN *;

//A partire da www genera Università e fai collegamenti
CALL apoc.load.xml("file:///d-www.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'www'] AS www_s
UNWIND www_s AS www
WITH www, [item in www._children WHERE item._type = "note"] AS note_s
UNWIND note_s AS note
MERGE (Uni:University {name:note._text})
RETURN count(Uni);
// create relationships :HOMEPAGE_OF
CALL apoc.load.xml("file:///d-www.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'www'] AS www_s
UNWIND www_s AS www
WITH www.key AS wwwKEY, [item in www._children WHERE item._type = "note"] AS note_s
UNWIND note_s AS note
MATCH (a:www {key: wwwKEY})
MATCH (Uni:University {name:note._text})
MERGE (a)-[:AFFILIATED_WITH]->(Uni)
RETURN *;
