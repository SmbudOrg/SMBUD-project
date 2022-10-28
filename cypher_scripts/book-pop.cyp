CALL apoc.load.xml("file:///book-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'book'] AS book_s
UNWIND book_s AS book
WITH book.key AS bookKEY,
     [item in book._children WHERE item._type = "title"][0] AS title,
     [item in book._children WHERE item._type = "pages"][0] AS pages,
     [item in book._children WHERE item._type = "url"][0] AS url,
     [item in book._children WHERE item._type = "citations"][0] AS citations,
     [item in book._children WHERE item._type = "ee"] AS ee_s, 
     [item in book._children WHERE item._type = "isbn"] AS isbn_s 


MERGE (a:Publication:Book {key: bookKEY})
SET 
    a.title = title._text,
    a.pages = toInteger(pages._text),
    a.url = url._text,
    a.citations = toInteger(citations._text),
    a.ee = [ee IN ee_s | ee._text],
    a.isbn = [isbn IN isbn_s | isbn._text]
RETURN count(a);


//Load Author nodes
CALL apoc.load.xml("file:///book-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'book'] AS book_s
UNWIND book_s AS book
WITH book, [item in book._children WHERE item._type = "author"] AS author_s
UNWIND author_s AS author
WITH author.orcid AS _orcid, author._text AS _name
MERGE (auth:Person {orcid:_orcid})
SET auth.name = _name
RETURN count(auth);
// create relationships :AUTHOR_OF
CALL apoc.load.xml("file:///book-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'book'] AS book_s
UNWIND book_s AS book
WITH book.key AS bookKEY, [item in book._children WHERE item._type = "author"] AS author_s
UNWIND author_s AS author
WITH bookKEY, author.orcid AS _orcid
MATCH (a:Book {key: bookKEY})
MATCH (auth:Person {orcid:_orcid})
MERGE (auth)-[:AUTHOR_OF]->(a)
RETURN count(*);

//Load Editor nodes
CALL apoc.load.xml("file:///book-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'book'] AS book_s
UNWIND book_s AS book
WITH book, [item in book._children WHERE item._type = "editor"] AS editor_s
UNWIND editor_s AS editor
WITH editor.orcid AS _orcid, editor._text AS _name
MERGE (edit:Person {orcid:_orcid})
SET edit.name = _name
RETURN count(edit);
// create relationships :EDITOR_OF
CALL apoc.load.xml("file:///book-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'book'] AS book_s
UNWIND book_s AS book
WITH book.key AS bookKEY, [item in book._children WHERE item._type = "editor"] AS editor_s
UNWIND editor_s AS editor
WITH bookKEY, editor.orcid AS _orcid
MATCH (a:Book {key: bookKEY})
MATCH (edit:Person {orcid:_orcid})
MERGE (edit)-[:EDITOR_OF]->(a)
RETURN *;


//Load Publisher nodes
CALL apoc.load.xml("file:///book-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'book'] AS book_s
UNWIND book_s AS book
WITH book, [item in book._children WHERE item._type = "publisher"] AS publisher_s
UNWIND publisher_s AS publisher
MERGE (publ:Publisher {name:publisher._text})
RETURN count(publ);
// create relationships :PUBLISHED_BY
CALL apoc.load.xml("file:///book-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'book'] AS book_s
UNWIND book_s AS book
WITH book.key AS bookKEY, [item in book._children WHERE item._type = "publisher"] AS publisher_s
UNWIND publisher_s AS publisher
MATCH (a:Book {key: bookKEY})
MATCH (publ:Publisher {name:publisher._text})
MERGE (a)-[:PUBLISHED_BY]->(publ)
RETURN *;

//Load Series nodes
CALL apoc.load.xml("file:///book-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = "book"] AS book_s
UNWIND book_s AS book
WITH book, 
	[item in book._children WHERE item._type = "series"][0] AS series_s,
	[item in book._children	WHERE item._type = "volume"][0] AS volume
UNWIND series_s AS series
MERGE (s:Series {name:series._text})
RETURN count(s);
// create relationships :CONTAINS
CALL apoc.load.xml("file:///book-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'book'] AS book_s
UNWIND book_s AS book
WITH book.key AS bookKEY, [item in book._children WHERE item._type = "series"][0] AS series,
	[item in book._children	WHERE item._type = "volume"][0] AS volume
MATCH (a:Book {key: bookKEY})
MATCH (s:Series {name:series._text})
MERGE (s)-[r:CONTAINS]->(a)
SET r.volume = toInteger(volume._text)
RETURN *;


//Load Year nodes
CALL apoc.load.xml("file:///book-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'book'] AS book_s
UNWIND book_s AS book
WITH book, [item in book._children WHERE item._type = "year"][0] AS year
WHERE year IS NOT NULL
MERGE (y:Year {year:toInteger(year._text)})
RETURN count(y);
// create relationships :PUBLISHED_IN
CALL apoc.load.xml("file:///book-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'book'] AS book_s
UNWIND book_s AS book
WITH book.key AS bookKEY, [item in book._children WHERE item._type = "year"][0] AS year
MATCH (a:Book {key: bookKEY})
MATCH (y:Year {year:toInteger(year._text)})
MERGE (a)-[:PUBLISHED_IN]->(y)
RETURN *;

//Load Keyword nodes
CALL apoc.load.xml("file:///book-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'book'] AS book_s
UNWIND book_s AS book
WITH book, [item in book._children WHERE item._type = "keyword"] AS keyword_s
UNWIND keyword_s AS keyword
MERGE (k:Keyword {keyword: keyword._text})
SET k.keyword = keyword._text
RETURN count(k);
// create relationships :ABOUT
CALL apoc.load.xml("file:///book-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'book'] AS book_s
UNWIND book_s AS book
WITH book.key AS bookKEY, [item in book._children WHERE item._type = "keyword"] AS keyword_s
UNWIND keyword_s AS keyword
WITH bookKEY, keyword
MATCH (a:Book {key: bookKEY})
MATCH (k:Keyword {keyword: keyword._text})
MERGE (a)-[:ABOUT]->(k)
RETURN *;

