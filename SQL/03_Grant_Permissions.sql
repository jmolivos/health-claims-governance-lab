-- Create  groups--
--CREATE GROUP `analysts`;
--CREATE GROUP `engineers`;
--CREATE GROUP `auditors`;

-- Se crean los usuarios a través de la plataforma de administración
/*
-- Create a group with users
CREATE GROUP analysts WITH USER `analysts@email.com`;
CREATE GROUP engineers WITH USER `engineers@email.com`;
CREATE GROUP auditors WITH USER `auditors@email.com`;
-- Al ser una cuenta free no permite crear roles, se crean directamente los permisos
*/

/* -- PERMISOS A NIVEL DE GRUPOS (COMO DEBE SER)
-- Catalog access (everyone needs this to reach anything inside)
GRANT USE CATALOG ON CATALOG atlas TO `analysts`;
GRANT USE CATALOG ON CATALOG atlas TO `engineers`;
GRANT USE CATALOG ON CATALOG atlas TO `auditors`;

-- BRONZE: engineers only
GRANT USE SCHEMA, SELECT, MODIFY ON SCHEMA atlas.bronze TO `engineers`;

-- SILVER: engineers write; analysts + auditors read
GRANT USE SCHEMA, SELECT, MODIFY ON SCHEMA atlas.silver TO `engineers`;
GRANT USE SCHEMA, SELECT ON SCHEMA atlas.silver TO `analysts`;
GRANT USE SCHEMA, SELECT ON SCHEMA atlas.silver TO `auditors`;

-- GOLD: engineers write; analysts + auditors read
GRANT USE SCHEMA, SELECT, MODIFY ON SCHEMA atlas.gold TO `engineers`;
GRANT USE SCHEMA, SELECT ON SCHEMA atlas.gold TO `analysts`;
GRANT USE SCHEMA, SELECT ON SCHEMA atlas.gold TO `auditors`;
*/


--PERMISOS A NIVEL DE USUARIO, NO ES UNA BUENA PRÁCTICA PERO ES NECESARIO EN LA VERSIÓN FREE
-- Catalog access (everyone needs this to reach anything inside)
GRANT USE CATALOG ON CATALOG atlas TO `analysts@email.com`;
GRANT USE CATALOG ON CATALOG atlas TO `engineers@email.com`;
GRANT USE CATALOG ON CATALOG atlas TO `auditors@email.com`;

-- BRONZE: engineers@email.com only
GRANT USE SCHEMA, SELECT, MODIFY ON SCHEMA atlas.bronze TO `engineers@email.com`;
GRANT CREATE TABLE ON SCHEMA atlas.bronze TO `engineers@email.com`;

-- SILVER: engineers@email.com write; analysts@email.com + auditors@email.com read
GRANT CREATE TABLE ON SCHEMA atlas.silver TO `engineers@email.com`;
GRANT USE SCHEMA, SELECT, MODIFY ON SCHEMA atlas.silver TO `engineers@email.com`;
GRANT USE SCHEMA, SELECT ON SCHEMA atlas.silver TO `analysts@email.com`;
GRANT USE SCHEMA, SELECT ON SCHEMA atlas.silver TO `auditors@email.com`;

-- GOLD: engineers@email.com write; analysts@email.com + auditors@email.com read
GRANT CREATE TABLE ON SCHEMA atlas.gold TO `engineers@email.com`;
GRANT USE SCHEMA, SELECT, MODIFY ON SCHEMA atlas.gold TO `engineers@email.com`;
GRANT USE SCHEMA, SELECT ON SCHEMA atlas.gold TO `analysts@email.com`;
GRANT USE SCHEMA, SELECT ON SCHEMA atlas.gold TO `auditors@email.com`;



SHOW GRANTS ON CATALOG atlas;
SHOW GRANTS ON SCHEMA atlas.bronze;
SHOW GRANTS ON SCHEMA atlas.silver;
SHOW GRANTS ON SCHEMA atlas.gold;
