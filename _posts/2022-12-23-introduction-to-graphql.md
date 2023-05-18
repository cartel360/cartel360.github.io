---
layout: post
title: Introduction to GraphQL
date: 2023-01-01 00:00:00 
description: GraphQL is a query language for your API, and a server-side runtime for executing queries using a type system you define for your data.
image:
    path: /assets/img/graphql.png 
tags: [Productivity, Software, Development] # add tag
categories: [Software Development]
published: true
---

**GraphQL** is a query language for your API, and a server-side runtime for executing queries using a type system you define for your data. GraphQL is supported by your current code and data rather than being dependent on any one database or storage engine.

GraphQL was designed by Facebook in 2012 and released to the public in 2015. GraphQl has proven to solve weaknesses with traditional REST architecture by making a new system that is declarative, client-driven and performant.

Kinds and fields on those types are defined, and then functions are provided for each field on each type to establish a GraphQL service. For illustration, a GraphQL service that displays the name and identity of the currently logged-in user (me) may resemble this:
```graphql
type Query{
    me: User
}

type User{
    id: ID
    name: String
}
```

## Characteristics of GraphQL
### **Hierarchical** 
In GraphQL the data returned follows the shape of the query. 
```graphql
{
    student(id: 1) {
        name
        course
        units {
            name
            code
        }
    }
}
```

In the above example, the query has been extended to include units which requests for name and code fields of each unit.

The output of the above example will look something like
```graphql
{
    "data": {
        "student": {
            "name": "John Doe",
            "course": "BIT",
            "units": [
                {
                    "name": "Operating Systems",
                    "code": "OS1"
                },
                {
                    "name": "Web Development",
                    "code": "WB1"
                }
                {
                    "name": "Discrete Maths",
                    "code": "DM1"
                }
               
            ]
        }
    }
}
```

### **Declarative** 
Queries in graphQL are declarative to mean the client will declare which fields one is interested in and the response will return only the declared fields.
```graphql
{
    student(id: 1) {
        name
        course
    }
}
```
In the above example the user requests for name and course  fields only, this results to a  more efficient which performs well than alternatives. The response returned will be like
```graphql
{
    "data": {
        "student": {
            "name": "John Doe",
            "course": "BIT
        }
    }
}
```

#### **Self Documenting**
Through tools like [GraphiQL](https://github.com/graphql/graphiql), documentation can be generated automatically. From the above examples we can try find out more information about the units type.
```graphql
{
    __schema {
        types {
            name
            description
        }
    }
}
```
The response returned will be like
```graphql
{
    "data": {
        "__schema": {
            "types": [
                {
                    "name": "Unit",
                    "description": "A subject like that a student can enroll to do within a specific course"
                }
            ]
        }
    }
}
```

### **Strongly Typed**
According to the GraphQL Type system, GraphQL is strongly-typed. Within a GraphQL server, types represent the capabilities of the values. Most programmers will be familiar with the GraphQL kinds, which include more complex values like objects as well as scalars (basic values) like characters, booleans, and numeric integers.

We can have our own type of the Unit object
```graphql
type Unit {
    name: String!
    code: String!
}
```

## GraphQL vs REST
With both systems, there are advantages and disadvantages of each, though GraphQL was developed to help fill in the gaps that REST could not fill.

| **Feature** | **GraphQL**                                                                                                                                                                                        | **REST**                                                                                                          |
|-----------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|
| Data Fetching   | Returns set of data of fields that were declared through declarative queries                                                                                                                        | Returns set of data that was determined on the server, this might be too much data                                 |
| Architecture    | This exchanges data over a single endpoint                                                                                                                                                         | This is defined by multiple endpoints on a server.                                                                |
| Versioning      | They are backwards compatible and no breaking changes can be noted                                                                                                                                 | Versioning endpoints are often in the URL itself e.g. /v1, /v2 etc.                                               |
| Caching         | Every request will be different but use single endpoint thus cannot take advantage of any built-in HTTP caching mechanisms                                                                          | Caching is integral part of REST using existing HTTP conventions for caching.                                     |
| Error Handling  | Here, there is no specification about using HTTP response codes for errors thus will resolve with 200 HTTP code for successful responses and include errors property with the corresponding data. | This utilizes different 400 level HTTP codes for client error and 200 level HTTP codes for successful responses. |

## How GraphQL Queries Work
Requests in GraphQL are made using a special format that is used the data.
Looking the examples I had given above we can use those to explain how GraphQL queries work in details.
-   **Show Student Information** - To request for a student information i.e name and course the student is pursuing, we need to send a request with the id of the specific student we want to get his/her information as below:
```graphql
{
    student(id: 1) {
        name
        course
    }
} 
```
<br>

-   **Show Student Information and Units** - So from the above example, what if we also wanted to view also the units that the student has registered to do, we will be required to still pass in the id of the student and add the extra fields we need:
```graphql
{
    student(id: 1) {
        name
        course
        units {
            name
            code
        }
    }
}
```

## Resolving GraphQL Queries
For us to use GraphQL, we need to make sure that our API can read and understand GraphQL queries. 

Let's take an exapmle of a blog API where we have authors' data and we have the articles' data. These two are separate entities and we need to define separate schemas in GraphQL for these.
```graphql
type Author {
    id: Int!
    name: String!
    email: String
    articles: [Article!]
}

type Article {
    id: Int!
    title: String!
    slug: String!
    published: Boolean!
    author: Author!
}
```
Looking at the above example we have two custom types, AUthor and Article. The exclamation mark(!) indicates non-nullable fields. To query these types we need mto define one of GraphQL's default types which is the _Query Type_.

The Query type is used to define data points for querying .
```graphql
{
    type Query {
        authors: [Author!]!,
        author(id: Int!): Author!
    }
}
```
The above definition exposes two points we can use to make our queries. The first one can fetch a collection of authors and the second one can fetch a single author given the id of the author.

You might be asking yourself now, we have the endpoints we can use but how do I connect these two query points to the data source? GraphQl has a concept known as _Resolvers_ which are functions that map to our querying points to return only the entity that has been requested by the user.
```javascript
function() {
    return authorsArray;
}
```
In the example above, that's how we can define a resolver for the authors collection query point and the resolver for specific author query point will look like below
```javascript
function({ id }){
    return authorsArray.find((author) => author.id == id);
}
```
> NB: The above two examples of resolvers is a representation in JavaScript











