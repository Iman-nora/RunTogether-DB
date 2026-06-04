# RunTogether-DataBase

PostgreSQL database for a collaborative sports social network : RunTogether - Data modeling, SQL Queries, and Recommendation system.

## Project Overview 

RunTogether is a Strava-like sports social network. This repository contains the full database layer : entity-relationship modeling, relational schema, table definitions, sample data, and SQL queries.

**Course** 

BD6 — Université Paris Cité, L3 Informatique — 2026

## Repository Structure 

- conception/           =>    Entity-Relationship diagram
- data/CSV              =>    Sample data (+100 tuples)
- ddl/                  =>    Table definitions and Integrity constraints  
- queries/              =>    24 SQL queries (joins, window functions, recursion, recommendation index)
- generate_data.py      =>    Data Generation Script
- import.sql            =>    CSV Import Script 
- report                =>    Project report 

## Getting started 

''''bash

#   Creation of the schema 
psql -U postgres -d runtogether -f ddl/create.sql

#   Import sample data 
psql -U postgres -d runtogether -f import.sql

''''

##  Key Features Covered

- Multi-table joins (up to 4 tables), subqueries and aggregations
- Self-join with correlated subquery (friend-of-friend recommendation)
