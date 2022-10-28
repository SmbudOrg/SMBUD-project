//Load dei www
CALL apoc.load.xml("www-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'www'] AS www_s
UNWIND www_s AS www
WITH www.key AS wwwKEY,
     [item in www._children WHERE item._type = "author"][0] AS author,
     [item in www._children WHERE item._type = "title"][0] AS title,
     [item in www._children WHERE item._type = "url"] AS urls,
     [item in www._children WHERE item._type = "last_month_visits"][0] as last_month_visits
MERGE (a:Website {key: wwwKEY})
SET 
    a.title = title._text,
    a.url = [url IN urls | url._text],
    a.last_month_visits = toInteger(last_month_visits._txt)
RETURN count(a);

//Load author nodes
CALL apoc.load.xml("file:///www-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'www'] AS www_s
UNWIND www_s AS www
WITH www, [item in www._children WHERE item._type = "author"] AS author_s
UNWIND author_s AS author
WITH author.orcid AS _orcid, author._text AS _name
MERGE (auth:Person {orcid:_orcid})
SET auth.name = _name
RETURN count(auth);
// create relationships :HOMEPAGE_OF
CALL apoc.load.xml("file:///www-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'www'] AS www_s
UNWIND www_s AS www
WITH www.key AS wwwKEY, [item in www._children WHERE item._type = "author"] AS author_s
UNWIND author_s AS author
WITH wwwKEY, author.orcid AS _orcid
MATCH (a:Website {key: wwwKEY})
MATCH (auth:Person {orcid:_orcid})
MERGE (a)-[:HOMEPAGE_OF]->(auth)
RETURN *;

//Load University nodes
CALL apoc.load.xml("file:///www-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'www'] AS www_s
UNWIND www_s AS www
WITH www, [item in www._children WHERE item._type = "note"] AS note_s
UNWIND note_s AS note
MERGE (Uni:University {name:note._text})
RETURN count(Uni);
// create relationships :AFFILIATED_TO
CALL apoc.load.xml("file:///www-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'www'] AS www_s
UNWIND www_s AS www
WITH www.key AS wwwKEY, [item in www._children WHERE item._type = "note"] AS note_s
UNWIND note_s AS note
MATCH (a:Website {key: wwwKEY})
MATCH (Uni:University {name:note._text})
MERGE (a)-[:AFFILIATED_TO]->(Uni)
RETURN *;
