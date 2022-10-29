//Load phd thesis nodes
CALL apoc.load.xml("file:///phdthesis-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'phdthesis'] AS phdthesis_s
UNWIND phdthesis_s AS phdthesis
WITH phdthesis.key AS phdthesisKEY,
     [item in phdthesis._children WHERE item._type = "title"][0] AS title,
     [item in phdthesis._children WHERE item._type = "ee"] AS ee_s,
     [item in phdthesis._children WHERE item._type = "isbn"] AS isbn_s,
     [item in phdthesis._children WHERE item._type = "pages"][0] AS pages,
     [item in phdthesis._children WHERE item._type = "citations"][0] AS citations

MERGE (t:Phdthesis:Publication{key:phdthesisKEY})
SET
          t.title = title._text,
          t.ee=[ee IN ee_s| ee._text],
          t.isbn=[isbn IN isbn_s| isbn._text],
          t.pages=toInteger(pages._text),
          t.citations = toInteger(citations._text)
RETURN count(t);


//Load Author nodes
CALL apoc.load.xml("file:///phdthesis-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'phdthesis'] AS phdthesis_s
UNWIND phdthesis_s AS phdthesis
WITH phdthesis,[item in phdthesis._children WHERE item._type = "author"] AS author_s
UNWIND author_s AS author
WITH author.orcid AS _orcid, author._text AS _name
MERGE (auth:Person {orcid:_orcid})
SET auth.name = _name,
auth.orcid = _orcid
RETURN count(auth);
// create relationships :AUTHOR_OF
CALL apoc.load.xml("file:///phdthesis-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'phdthesis'] AS phdthesis_s
UNWIND phdthesis_s AS phdthesis
WITH phdthesis.key AS phdthesisKEY,
     [item in phdthesis._children WHERE item._type = "author"] AS author_s
UNWIND author_s AS author
WITH phdthesisKEY, author.orcid AS _orcid
MATCH (t:Phdthesis {key: phdthesisKEY})
MATCH (auth:Person {orcid:_orcid})
MERGE (auth)-[r:AUTHOR_OF]->(t)
RETURN count(r);




//Load Year nodes
CALL apoc.load.xml("file:///phdthesis-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'phdthesis'] AS phdthesis_s
UNWIND phdthesis_s AS phdthesis
WITH phdthesis,[item in phdthesis._children WHERE item._type = "year"][0] AS year
WHERE year IS NOT NULL
MERGE (y:Year {year:toInteger(year._text)})
RETURN count(y);
// create relationships :PUBLISHED_IN
CALL apoc.load.xml("file:///phdthesis-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'phdthesis'] AS phdthesis_s
UNWIND phdthesis_s AS phdthesis
WITH phdthesis.key AS phdthesisKEY, [item in phdthesis._children WHERE item._type = "year"][0] AS year
MATCH (t:Phdthesis {key: phdthesisKEY})
MATCH (y:Year {year:toInteger(year._text)})
MERGE (t)-[:PUBLISHED_IN]->(y)
RETURN *;


//Load University nodes
CALL apoc.load.xml("file:///phdthesis-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'phdthesis'] AS phdthesis_s
UNWIND phdthesis_s AS phdthesis
WITH phdthesis, [item in phdthesis._children WHERE item._type = "school"] AS uni_s
UNWIND uni_s AS uni
MERGE (u:University {name: uni._text})
RETURN count(u);
// create relationships :ABOUT
CALL apoc.load.xml("file:///phdthesis-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'phdthesis'] AS phdthesis_s
UNWIND phdthesis_s AS phdthesis
WITH phdthesis.key AS phdthesisKEY, [item in phdthesis._children WHERE item._type = "school"] AS uni_s
UNWIND uni_s AS uni
WITH phdthesisKEY, uni
MATCH (a:Phdthesis {key: phdthesisKEY})
MATCH (u:University {name: uni._text})
MERGE (a)-[:PRODUCED_BY]->(u)
RETURN * LIMIT 100;

//Load Publisher nodes
CALL apoc.load.xml("file:///phdthesis-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'phdthesis'] AS phdthesis_s
UNWIND phdthesis_s AS phdthesis
WITH phdthesis, [item in phdthesis._children WHERE item._type = "publisher"] AS publisher_s
UNWIND publisher_s AS publisher
MERGE (publ:Publisher {name:publisher._text})
RETURN count(publ);
// create relationships :PUBLISHED_BY
CALL apoc.load.xml("file:///phdthesis-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'phdthesis'] AS phdthesis_s
UNWIND phdthesis_s AS phdthesis
WITH phdthesis.key AS phdthesisKEY, [item in phdthesis._children WHERE item._type = "publisher"] AS publisher_s
UNWIND publisher_s AS publisher
MATCH (t:Phdthesis {key: phdthesisKEY})
MATCH (publ:Publisher {name:publisher._text})
MERGE (t)-[:PUBLISHED_BY]->(publ)
RETURN *;

//Load Keyword nodes
CALL apoc.load.xml("file:///phdthesis-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'phdthesis'] AS phdthesis_s
UNWIND phdthesis_s AS phdthesis
WITH phdthesis, [item in phdthesis._children WHERE item._type = "keyword"] AS keyword_s
UNWIND keyword_s AS keyword
MERGE (k:Keyword {keyword: keyword._text})
SET k.keyword = keyword._text
RETURN count(k);
// create relationships :ABOUT
CALL apoc.load.xml("file:///phdthesis-db.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'phdthesis'] AS phdthesis_s
UNWIND phdthesis_s AS phdthesis
WITH phdthesis.key AS phdthesisKEY, [item in phdthesis._children WHERE item._type = "keyword"] AS keyword_s
UNWIND keyword_s AS keyword
WITH phdthesisKEY, keyword
MATCH (a:Phdthesis {key: phdthesisKEY})
MATCH (k:Keyword {keyword: keyword._text})
MERGE (a)-[:ABOUT]->(k)
RETURN * LIMIT 100;

