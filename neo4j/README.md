## Exercise 1  
### 1.1  
##### MATCH(n) return n  
  
### 1.2 
#####CALL db.schema()

### 1.3
##### MATCH(p:Person) return p

### 1.4
##### MATCH(m:Movie) return m  

## Exercise 2    
### 2.1  
##### MATCH(m:Movie {released:2003}) RETURN m  
  
### 2.3  
##### CALL db.propertyKeys 
  
### 2.4  
##### MATCH(m:Movie {released: 2006}) RETURN m.title 
  
### 2.5  
##### MATCH(m:Movie) RETURN m.title, m.released, m.tagline 
  
### 2.6  
##### MATCH(m:Movie) RETURN m.title AS `movie title`, m.released AS released, m.tagline AS tagLine 
  
## Exercise 3  
  
### 3.1  
##### CALL db.schema 

### 3.2  
##### MATCH(p:Person)-[:WROTE]->(:Movie {title: 'Speed Racer'}) RETURN p.name
    
### 3.3  
##### MATCH(m:Movie)<--(:Person {name: 'Tom Hanks'}) RETURN m.title 
  
### 3.4  
##### MATCH(m:Movie)-[rel]-(:Person {name: 'Tom Hanks'}) RETURN m.title, type(rel)
  
### 3.5  
##### MATCH(m:Movie)-[rel:ACTED_IN]-(:Person {name: 'Tom Hanks'}) RETURN m.title, rel.roles  
  
## Exercise 4  
  
### 4.1  
##### MATCH(p:Person)-[:ACTED_IN]->(m:Movie) WHERE p.name = 'Tom Cruise' RETURN m.title as Movie

### 4.2  
##### MATCH(p:Person) WHERE p.born >= 1970 AND p.born < 1980 RETURN p.name as Name, p.born as `Year Born`
    
### 4.3  
##### Match(p:Person)-[:ACTED_IN]->(m:Movie) WHERE p.born > 1960 AND m.title='The Matrix' RETURN p.name as Name, p.born as `Year Born`
  
### 4.4  
##### MATCH(m) WHERE m:Movie AND m.released = 1999 RETURN m.title
  
### 4.5  
##### MATCH(p)-[rel]->(m) WHERE p:Person AND type(rel) = 'WROTE' AND m:Movie RETURN p.name as Name, m.title as Movie  
  
### 4.6  
##### MATCH(p:Person) WHERE NOT exists(p.tagline) RETURN p.name as Name

### 4.7  
##### MATCH(p:Person)-[rel]->(m:Movie) WHERE exists(rel.rating) RETURN p.name as Name, m.title as Movie, rel.rating as Rating
    
### 4.8  
##### MATCH(p:Person)-[:ACTED_IN]->(:Movie) WHERE p.name STARTS WITH 'James' RETURN p.name
  
### 4.9  
##### MATCH(p:Person)-[r:REVIEWED]->(m:Movie) WHERE toLower(r.summary) CONTAINS 'dark' RETURN m.title as Movie, r.summary as Summary
  
### 4.10  
##### MATCH(p:Person)-[:PRODUCED]->(m:Movie) WHERE NOT ((p)-[:DIRECTED]->(:Movie)) RETURN p.name as Productor, m.title as Movie
  
### 4.11  
##### MATCH(p:Person)-[:ACTED_IN]->(m:Movie)<-[:ACTED_IN]-(op:Person) WHERE exists( (op)-[:DIRECTED]->(m)) RETURN  p.name as Actor, op.name as `Actor/Director`, m.title as Movie

### 4.12  
##### MATCH(m:Movie) WHERE m.released in [1995, 1999, 2000] RETURN m.title, m.released
    
### 4.13  
#####  MATCH(p:Person)-[r:ACTED_IN]->(m:Movie) WHERE m.title in r.roles RETURN m.title as Movie, p.name as Actor
  
## Exercise 5  

### 5.1  
##### MATCH(p:Person)-[:ACTED_IN]->(m:Movie)<-[:PRODUCED]-(pd:Person),(p2:Person)-[:DIRECTED]->(m) WHERE m.title = 'The Matrix Reloaded'  RETURN m.title as Movie, pd.name as Productor, p2.name as Director 
  
### 5.2  
##### MATCH(p1:Person)-[:FOLLOWS]-(p2:Person) WHERE p1.name = 'Angela Scope' RETURN p1.name, p2.name
  
### 5.3  
##### MATCH(p1:Person)-[:FOLLOWS*3]-(p2:Person) WHERE p1.name = 'Angela Scope' RETURN p1, p2
  
### 5.4  
##### MATCH(p1:Person)-[:FOLLOWS*1..2]-(p2:Person) WHERE p1.name = 'Angela Scope' RETURN p1, p2
  
### 5.5  
##### MATCH(p1:Person)-[:FOLLOWS*]-(p2:Person) WHERE p1.name = 'Angela Scope' RETURN p1, p2
  
### 5.6  
##### MATCH(p:Person) WHERE p.name STARTS WITH 'Angela' OPTIONAL MATCH (p)-[:DIRECTED]->(m:Movie)RETURN p.name, m.title
  
### 5.7  
##### MATCH(p:Person)-[:ACTED_IN]->(m:Movie) RETURN p.name as actor, collect(m.title) AS `movie list`  
  
### 5.8  
##### MATCH(p:Person)-[:ACTED_IN]->(m:Movie)<-[:ACTED_IN]-(p2:Person) WHERE p.name = 'Tom Cruise' RETURN m.title as Movie, collect(p2.name) AS `co actors`
  
### 5.9  
##### MATCH(p:Person)-[:DIRECTED]->(m:Movie) RETURN m.title as Movie, count(p) as Director, collect(p.name) as `Directors name`
  
### 5.10  
##### MATCH(p:Person)-[:DIRECTED]->(m:Movie)<-[:ACTED_IN]-(pd:Person) RETURN p.name as Director ,count(pd) as `munber actors`, collect(pd.name) as `Actors`
  
### 5.11  
##### MATCH(p:Person)-[:ACTED_IN]->(m:Movie) WITH p, count(p) as totalMovies, collect(m.title) as movies WHERE totalMovies = 5 RETURN p.name, movies
  
### 5.12  
##### MATCH(m:Movie) WITH m, size((:Person)-[:DIRECTED]->(m)) as directors WHERE directors >= 2 OPTIONAL MATCH (p:Person)-[:FOLLOWS]->(m) RETURN m.title, p.name as Follows
  

## Exercise 6  
  
### 6.1  
##### MATCH(a:Person)-[:ACTED_IN]->(m:Movie) WHERE m.released >= 1990 RETURN m.released, m.title, collect(a.name)
  
### 6.2  
##### MATCH(a:Person)-[:ACTED_IN]->(m:Movie) WHERE m.released >= 1990 RETURN m.released, collect(m.title), collect(a.name)
  
### 6.3  
##### MATCH(a:Person)-[:ACTED_IN]->(m:Movie) WHERE m.released >= 1990 RETURN m.released, collect(DISTINCT(m.title)), collect(a.name)
  
### 6.4  
##### MATCH(a:Person)-[:ACTED_IN]->(m:Movie) WHERE m.released >= 1990 RETURN m.released, collect(DISTINCT(m.title)), collect(a.name) ORDER BY m.released DESC
  
### 6.5  
##### MATCH(a:Person)-[r:REVIEWED]->(m:Movie) RETURN m.title, r.rating ORDER BY r.rating DESC LIMIT 5
  
### 6.6  
##### MATCH(p:Person)-[:ACTED_IN]->(m:Movie) WITH p, count(p) as totalMovies, collect(m.title) as movies WHERE totalMovies <= 3 RETURN p.name, movies

  
## Exercise 7  
  
### 7.1  
##### MATCH(p:Person)-[:ACTED_IN]->(m:Movie) WITH m, count(m) as totalMovies, collect(p.name) as actors RETURN m.title, totalMovies, actors ORDER BY size(actors)  
  
### 7.2  
##### MATCH (p:Person)-[:ACTED_IN]->(m:Movie) WITH p, collect(m) AS movies RETURN p.name, movies
  
### 7.3  
##### MATCH (p:Person)-[:ACTED_IN]->(m:Movie) WITH p, collect(m) AS movies WHERE size(movies) > 3 WITH p, movies UNWIND movies as movie RETURN p.name, movie.title
  
### 7.4  
##### MATCH(a:Person)-[:ACTED_IN]->(m:Movie) WHERE a.name = 'Keanu Reeves' RETURN  m.title, m.released, date().year - m.released as yearsAgo, m.released - a.born AS `age of Reeves` ORDER BY yearsAgo
 
  
## Exercise 8   
  
### 8.1  
##### CREATE (:Movie {title: 'Spider Man'})
  
### 8.2  
##### MATCH(m:Movie) WHERE m.title = 'Spider Man' RETURN m.title
  
### 8.3  
##### CREATE (:Person {name: 'Leandro Sampaio'})
  
### 8.4  
##### MATCH(p:Person) WHERE p.name = 'Leandro Sampaio' RETURN p.name
  
### 8.5  
##### MATCH(m:Movie) WHERE m.title = 'Spider Man' SET m:BestMovie RETURN labels(m)
  
### 8.6  
##### MATCH(m:BestMovie) RETURN m.title
  
### 8.7  
##### MATCH(p:Person) WHERE p.name STARTS WITH 'Leandro' SET p:Female
  
### 8.8  
##### MATCH(p:Female) RETURN p.name
  
### 8.9  
##### MATCH (p:Female) REMOVE p:Female
  
### 8.10  
##### CALL db.schema
  
### 8.11  
##### MATCH(m:Movie) WHERE m.title = 'Spider Man' SET m:BestMovie, m.released = 2003, m.tagline = "I have not idea", m.minutes = 120
  
### 8.12  
##### MATCH(m:BestMovie) WHERE m.title = 'Spider Man' RETURN m
  
### 8.13  
##### MATCH(p:Person) WHERE p.name = 'Leandro Sampaio' SET p.born = 1986, p.birthPlace = 'Faxinal'
  
### 8.14  
##### MATCH(p:Person) WHERE p.name = 'Leandro Sampaio' RETURN p
  
### 8.15  
##### MATCH(m:Movie) WHERE m.title = 'Spider Man' SET m.minutes = null
  
### 8.16  
##### MATCH(m:Movie) WHERE m.title = 'Spider Man' RETURN m
  
### 8.17  
##### MATCH(p:Person) WHERE p.name = 'Leandro Sampaio' SET p.birthPlace = null
  
### 8.18  
##### MATCH(p:Person) WHERE p.name = 'Leandro Sampaio' RETURN p
  
  
## Exercise 9   
  
### 9.1  
##### MATCH(m:Movie) WHERE m.title = 'Spider Man' MATCH (p:Person) WHERE p.name = 'Leandro Sampaio' OR p.name = 'Leide Daiane' OR p.name = 'Andrei Souza' CREATE (p)-[:ACTED_IN]->(m)
  
### 9.2  
##### MATCH(m:Movie) WHERE m.title = 'Spider Man' MATCH (p:Person) WHERE p.name = 'Robert Zemeckis'CREATE (p)-[:DIRECTED]->(m)
  
### 9.3  
##### MATCH (p1:Person) WHERE p1.name = 'Leandro Sampaio' MATCH (p2:Person) WHERE p2.name = 'Leide Daiane' CREATE (p1)-[:HELPED]->(p2)
  
### 9.4  
##### MATCH (p:Person)-[rel]-(m:Movie) WHERE m.title = 'Spider Man'RETURN p, rel, m
  
### 9.5  
##### MATCH(p:Person)-[rel:ACTED_IN]->(m:Movie) WHERE m.title = 'Spider Man' SET rel.roles = CASE p.name WHEN 'Leandro Sampaio' THEN ['Spider Man'] WHEN 'Leide Daiane' THEN ['Marry Jane'] WHEN 'Andrei Souza' THEN ['Green Elf'] END
  
### 9.6  
##### MATCH(p1:Person)-[rel:HELPED]->(p2:Person) WHERE p1.name = 'Leandro Sampaio' AND p2.name = 'Leide Daiane'SET rel.research = 'war history'
  
### 9.7  
##### call db.propertyKeys
  
### 9.8  
##### call db.schema
  
### 9.9  
##### MATCH(p:Person)-[rel:ACTED_IN]->(m:Movie) WHERE m.title = 'Spider Man' RETURN p.name, rel.roles
  
### 9.10  
##### MATCH (p:Person)-[rel:HELPED]-(p2:Person) RETURN p.name, rel, p2.name
  
### 9.11  
##### MATCH(p:Person)-[rel:ACTED_IN]->(m:Movie) WHERE m.title = 'Spider Man' AND p.name = 'Leide Daiane' SET rel.roles =['Unknown']
  
### 9.12  
##### MATCH(p1:Person)-[rel:HELPED]->(p2:Person)WHERE p1.name = 'Leandro Sampaio' AND p2.name = 'Leide Daiane' REMOVE rel.research
  
### 9.13  
##### MATCH(p:Person)-[rel:ACTED_IN]->(m:Movie) WHERE m.title = 'Spider Man'return p, rel, m

## Exercise 10   
  
### 10.1  
##### MATCH(:Person)-[rel:HELPED]-(:Person) DELETE rel
  
### 10.2  
##### MATCH(:Person)-[rel:HELPED]-(:Person) RETURN rel
  
### 10.3  
##### MATCH(p:Person)-[rel]-(m:Movie)WHERE m.title = 'Spider Man' RETURN p, rel, m
  
### 10.4  
##### MATCH(m:Movie) WHERE m.title = 'Spider Man' DELETE m
  
### 10.5  
##### MATCH(m:Movie) WHERE m.title = 'Spider Man' DETACH DELETE m
  
### 9.6  
##### MATCH(p:Person)-[rel]-(m:Movie) WHERE m.title = 'Spider Man' RETURN p, rel, m
  

  
  
