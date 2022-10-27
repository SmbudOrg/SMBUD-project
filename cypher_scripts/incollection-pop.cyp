
//Load incollection nodes
CALL apoc.load.xml("file:///incollection-volume.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'incollection'] AS incollection_s
UNWIND incollection_s AS incollection
WITH incollection.key AS incollectionKEY,
     incollection.mdate AS incollectionMDATE,
     [item in incollection._children WHERE item._type = "title"][0] AS title,
     [item in incollection._children WHERE item._type = "ee"] AS ee_s,
     [item in incollection._children WHERE item._type = "cite"] AS cite_s,
     [item in incollection._children WHERE item._type = "pages"][0] AS pages,
     [item in incollection._children WHERE item._type = "citations"][0] AS citations

MERGE (a:Incollection:Publication{key:incollectionKEY})
SET
          a.mdate = incollectionMDATE,
          a.title = title._text,
          a.ee=[ee IN ee_s| ee._text],
          a.cite=[cite IN cite_s| cite._text],
          a.pages=pages._text,
          a.citations=citations._text
RETURN count(a);


//Load Author nodes
CALL apoc.load.xml("file:///incollection-volume.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'incollection'] AS incollection_s
UNWIND incollection_s AS incollection
WITH [item in incollection._children WHERE item._type = "author"] AS author_s
UNWIND author_s AS author
WITH author.orcid AS _orcid, author._text AS _name
MERGE (auth:Person {orcid:_orcid})
SET auth.name = _name,
auth.orcid = _orcid
RETURN count(auth);
// create relationships :AUTHOR_OF
CALL apoc.load.xml("file:///incollection-volume.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'incollection'] AS incollection_s
UNWIND incollection_s AS incollection
WITH incollection.key AS incollectionKEY,
     [item in incollection._children WHERE item._type = "author"] AS author_s
UNWIND author_s AS author
WITH incollectionKEY, author.orcid AS _orcid
MATCH (a:Incollection {key: incollectionKEY})
MATCH (auth:Person {orcid:_orcid})
MERGE (auth)-[r:AUTHOR_OF]->(a)
RETURN count(r);




// create relationships :PART_OF
CALL apoc.load.xml("file:///incollection-volume.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'incollection'] AS incollection_s
UNWIND incollection_s AS incollection
WITH incollection.key AS incollectionKEY,
     [item in incollection._children WHERE item._type = "crossref"][0] AS crossref,
     [item in incollection._children WHERE item._type = "number"][0] AS number

MATCH (a: Incollection{key: incollectionKEY})
MATCH (p:Publication {key: crossref._text})
MERGE (a)-[r:COLLECTED_IN]->(p)
SET r.crossref = crossref._text,
    r.number = number._text
RETURN DISTINCT count(r);


// Year, Publisher nodes and their relationships with collection/book already defined in the book category

// create relationships :CITES
CALL apoc.load.xml("file:///incollection-volume.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'incollection'] AS incollection_s
UNWIND incollection_s AS incollection
WITH incollection.key AS incollectionKEY,
     [item in incollection._children WHERE item._type = "cite"] AS cite_s
UNWIND cite_s AS cite
MATCH (a:Incollection {key: incollectionKEY})
MATCH (o {key: cite._text})
MERGE (a)-[r:CITES]->(o)
RETURN (a)-[r]-(o);



//Load Keyword nodes
CALL apoc.load.xml("file:///incollection-volume.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'incollection'] AS incollection_s
UNWIND incollection_s AS incollection
WITH [item in incollection._children WHERE item._type = "keyword"] AS keyword_s
UNWIND keyword_s AS keyword
MERGE (k:Keyword {keyword: keyword._text})
SET k.keyword = keyword._text
RETURN count(k);


// create relationships :ABOUT
CALL apoc.load.xml("file:///incollection-volume.xml") YIELD value
UNWIND value._children AS foo
WITH [x in foo WHERE x._type = 'incollection'] AS incollection_s
UNWIND incollection_s AS incollection
WITH incollection.key AS incollectionKEY,
     [item in incollection._children WHERE item._type = "keyword"] AS keyword_s
UNWIND keyword_s AS keyword
WITH incollectionKEY, keyword
MATCH (a:Incollection {key: incollectionKEY})
MATCH (k:Keyword{keyword: keyword._text})
MERGE (a)-[r:ABOUT]->(k)
RETURN *;



