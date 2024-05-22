
-------------------------------------------
-- clean up environment
-------------------------------------------

USE ROLE ACCOUNTADMIN;
DROP DATABASE IF EXISTS ANALYTICS;
DROP DATABASE IF EXISTS ANALYTICS_DEV;
DROP DATABASE IF EXISTS ANALYTICS;
DROP DATABASE IF EXISTS DBT_DEV;
DROP DATABASE IF EXISTS DBT_PROD;
DROP DATABASE IF EXISTS DBT;
DROP DATABASE IF EXISTS RAW;

-------------------------------------------
-- dbt credentials
-------------------------------------------

USE ROLE ACCOUNTADMIN;

-- dbt roles

CREATE OR REPLACE ROLE dbt_dev_role;
CREATE OR REPLACE ROLE dbt_prod_role;

-- create dbt role to be used as part of enablement sessions

CREATE OR REPLACE USER dbt_user PASSWORD = "Arch2024Enablement!";

-- create admin user to be used by Kubrick Team should access be required

CREATE OR REPLACE USER KUBRICKADMIN
PASSWORD = 'Arch2024Enablement!'
LOGIN_NAME = 'KUBRICKADMIN'
EMAIL = 'bavandeepmalhi@kubrickgroup.com'
MUST_CHANGE_PASSWORD = false
DEFAULT_WAREHOUSE = COMPUTE_WH;

GRANT ROLE ACCOUNTADMIN to USER KUBRICKADMIN;


GRANT ROLE dbt_dev_role,dbt_prod_role TO USER dbt_user;
GRANT ROLE dbt_dev_role,dbt_prod_role TO ROLE sysadmin;


-------------------------------------------
-- dbt objects
-------------------------------------------

USE ROLE accountadmin;

CREATE OR REPLACE WAREHOUSE dbt_dev_wh WITH WAREHOUSE_SIZE = 'XSMALL' AUTO_SUSPEND = 60 AUTO_RESUME = TRUE MIN_CLUSTER_COUNT = 1 MAX_CLUSTER_COUNT = 1 INITIALLY_SUSPENDED = TRUE;

CREATE OR REPLACE WAREHOUSE dbt_dev_heavy_wh WITH WAREHOUSE_SIZE = 'LARGE' AUTO_SUSPEND = 60 AUTO_RESUME = TRUE MIN_CLUSTER_COUNT = 1 MAX_CLUSTER_COUNT = 1 INITIALLY_SUSPENDED = TRUE;

CREATE OR REPLACE WAREHOUSE dbt_prod_wh WITH WAREHOUSE_SIZE = 'XSMALL' AUTO_SUSPEND = 60 AUTO_RESUME = TRUE MIN_CLUSTER_COUNT = 1 MAX_CLUSTER_COUNT = 1 INITIALLY_SUSPENDED = TRUE;

CREATE OR REPLACE WAREHOUSE dbt_prod_heavy_wh WITH WAREHOUSE_SIZE = 'LARGE' AUTO_SUSPEND = 60 AUTO_RESUME = TRUE MIN_CLUSTER_COUNT = 1 MAX_CLUSTER_COUNT = 1 INITIALLY_SUSPENDED = TRUE;

GRANT ALL ON WAREHOUSE dbt_dev_wh TO ROLE dbt_dev_role;
GRANT ALL ON WAREHOUSE dbt_dev_heavy_wh TO ROLE dbt_dev_role;
GRANT ALL ON WAREHOUSE dbt_prod_wh TO ROLE dbt_prod_role;
GRANT ALL ON WAREHOUSE dbt_prod_heavy_wh TO ROLE dbt_prod_role;

USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE DATABASE DBT_DEV;
CREATE OR REPLACE DATABASE DBT_PROD;
CREATE OR REPLACE DATABASE RAW;
CREATE OR REPLACE SCHEMA RAW.TECH_STORE;
CREATE OR REPLACE SCHEMA RAW.PAYMENT_APP;

---------------------------------------
-- CREATE SOURCE TABLES
---------------------------------------


-- Create Source Tables
/* Tech Store */
create or replace table raw.tech_store.employee (
  id int,
  fname varchar null,
  lname varchar null,
  hiredate date null,
  enddate date null
);

create or replace table raw.tech_store.product (
  id int,
  name varchar null,
  category varchar null,
  price number(18,2) null,
  currency varchar null
);

create or replace table raw.tech_store.orders (
  id int,
  productid int,
  quantity int,
  userid int,
  customerid int,
  datetime timestamp
);

create or replace table raw.tech_store.customer (
  id int,
  name varchar,
  cityid int,
  mainsalesrepid int,
  createdatetime timestamp,
  updatedatetime timestamp,
  active varchar
);

create or replace table raw.tech_store.city (
  id int,
  name varchar,
  stateid int,
  zipid int
);

create or replace table raw.tech_store.state (
  id int,
  name varchar,
  code varchar
);

create or replace table raw.tech_store.zip (
  id int,
  code varchar
);

/* Payment App */
create or replace table raw.payment_app.transactions (
  id int,
  date date,
  payload variant
);

---
/* ============================
Load Source Tables w/ Raw Data
============================*/
/* Tech Store */
insert into raw.tech_store.employee (id,fname,lname,hiredate,enddate) values
  (1,'Bav','Malhi','1/1/2019',null),
  (2,'LeBron','James','5/15/2020',null),
  (3,'Stephen','Curry','8/22/2021',null),
  (4,'Michael','Jordan','5/7/2019','5/15/2021'),
  (5,'Tim','Duncan','4/7/2019','2/1/2020');

insert into raw.tech_store.product (id,name,category,price,currency) values
  (1,'Laptop','Computers','1500','USD'),
  (2,'Mouse','Computers','50','USD'),
  (3,'Monitor','Computers','225','USD'),
  (4,'Laptop Stand','Accessories','40','USD'),
  (5,'Power Cords','Accessories','15','USD'),
  (6,'Speakers','Audio','200','USD'),
  (7,'Microphone','Audio','140','USD'),
  (8,'Headphones','Audio','150','USD'),
  (9,'Camera','Video','750','USD'),
  (10,'Editing Software','Software','250','USD');

insert into raw.tech_store.orders (id,productid,quantity,userid,customerid,datetime) values
  (1,7,1,1,9,'1/24/2019 02:35:22'),
  (2,3,4,5,6,'11/28/2019 13:51:09'),
  (3,5,5,2,9,'5/16/2020 13:57:49'),
  (4,7,4,2,6,'9/17/2020 01:38:04'),
  (5,10,4,4,7,'3/17/2020 23:10:30'),
  (6,6,3,2,2,'7/11/2020 01:51:09'),
  (7,5,1,5,2,'7/11/2019 02:26:07'),
  (8,6,5,2,10,'5/29/2020 07:37:44'),
  (9,7,2,3,6,'10/7/2021 18:09:58'),
  (10,6,5,5,7,'6/17/2019 08:11:14'),
  (11,2,3,5,10,'11/10/2019 08:58:46'),
  (12,9,2,3,6,'10/3/2021 07:56:48'),
  (13,6,3,4,4,'4/5/2020 22:37:29'),
  (14,4,4,1,7,'1/15/2019 08:08:22'),
  (15,10,5,2,3,'7/15/2020 09:29:17'),
  (16,1,2,4,2,'8/21/2020 18:08:22'),
  (17,8,5,5,4,'12/3/2019 05:36:28'),
  (18,6,5,3,3,'11/30/2021 04:23:21'),
  (19,9,5,3,4,'12/9/2021 13:51:57'),
  (20,10,4,1,10,'1/4/2019 21:50:38'),
  (21,3,4,1,8,'1/8/2019 19:16:48'),
  (22,4,1,1,9,'2/5/2019 02:39:33'),
  (23,10,2,4,7,'5/29/2019 06:15:43'),
  (24,2,2,5,10,'9/18/2019 12:41:58'),
  (25,5,3,2,2,'6/29/2020 23:18:34');

insert into raw.tech_store.customer (id,name,cityid,mainsalesrepid,createdatetime,updatedatetime,active) values
  (1,'Bulls',1,4,'10/1/2018 16:42:12','10/1/2018 16:42:12','yes'),
  (2,'76ers',2,1,'10/2/2018 16:42:12','10/2/2018 16:42:12','yes'),
  (3,'Warriors',3,3,'10/3/2018 16:42:12','10/3/2018 16:42:12','yes'),
  (4,'Heat',4,2,'10/4/2018 16:42:12','10/4/2018 16:42:12','yes'),
  (5,'Celtics',5,4,'12/15/2018 19:31:48','12/16/2018 19:31:48','yes'),
  (6,'Rockets',6,5,'12/16/2018 19:31:48','12/17/2018 19:31:48','yes'),
  (7,'Lakers',7,2,'12/17/2018 19:31:48','12/18/2018 19:31:48','yes'),
  (8,'Trail Blazers',8,3,'1/1/2019 08:15:00','1/2/2019 08:15:00','yes'),
  (9,'Mavericks',9,5,'1/2/2019 08:15:00','1/3/2019 08:15:00','yes'),
  (10,'Magic',10,1,'1/3/2019 08:15:00','1/4/2019 08:15:00','yes');

insert into raw.tech_store.city (id,name,stateid,zipid) values
  (1,'Chicago',1,1),
  (2,'Philadelphia',2,2),
  (3,'San Francisco',3,3),
  (4,'Miami',4,4),
  (5,'Boston',5,5),
  (6,'Houston',6,6),
  (7,'Los Angeles',3,7),
  (8,'Portland',7,8),
  (9,'Dallas',6,9),
  (10,'Orlando',4,10);

insert into raw.tech_store.state (id,name,code) values
  (1,'Illinois','IL'),
  (2,'Pennsylvania','PA'),
  (3,'California','CA'),
  (4,'Florida','FL'),
  (5,'Massachusetts','MA'),
  (6,'Texas','TX'),
  (7,'Oregon','OR');

insert into raw.tech_store.zip (id,code) values
  (1,'60612'),
  (2,'19109'),
  (3,'94158'),
  (4,'33132'),
  (5,'02114'),
  (6,'77002'),
  (7,'90015'),
  (8,'97227'),
  (9,'75219'),
  (10,'32801');

/* Payment App */
insert into raw.payment_app.transactions (id,date,payload)
  select 9000100,'8/14/2019',parse_json($${ "order_id" : "1", "date" : "43489", "product_id" : "7", "cost_per" : "140", "quantity" : "1", "amount" : "140", "tax" : "8.4", "total_charged" : "148.4" }$$) union all
  select 9000101,'9/11/2021',parse_json($${ "order_id" : "2", "date" : "43797", "product_id" : "3", "cost_per" : "225", "quantity" : "4", "amount" : "900", "tax" : "54", "total_charged" : "954" }$$) union all
  select 9000102,'5/19/2020',parse_json($${ "order_id" : "3", "date" : "43967", "product_id" : "5", "cost_per" : "15", "quantity" : "5", "amount" : "75", "tax" : "4.5", "total_charged" : "79.5" }$$) union all
  select 9000103,'9/5/2021',parse_json($${ "order_id" : "4", "date" : "44091", "product_id" : "7", "cost_per" : "140", "quantity" : "4", "amount" : "560", "tax" : "33.6", "total_charged" : "593.6" }$$) union all
  select 9000104,'1/3/2019',parse_json($${ "order_id" : "5", "date" : "43907", "product_id" : "10", "cost_per" : "250", "quantity" : "4", "amount" : "1000", "tax" : "60", "total_charged" : "1060" }$$) union all
  select 9000105,'9/25/2020',parse_json($${ "order_id" : "6", "date" : "44023", "product_id" : "6", "cost_per" : "200", "quantity" : "3", "amount" : "600", "tax" : "36", "total_charged" : "636" }$$) union all
  select 9000106,'11/29/2019',parse_json($${ "order_id" : "7", "date" : "43657", "product_id" : "5", "cost_per" : "15", "quantity" : "1", "amount" : "15", "tax" : "0.9", "total_charged" : "15.9" }$$) union all
  select 9000107,'8/30/2021',parse_json($${ "order_id" : "8", "date" : "43980", "product_id" : "6", "cost_per" : "200", "quantity" : "5", "amount" : "1000", "tax" : "60", "total_charged" : "1060" }$$) union all
  select 9000108,'1/3/2019',parse_json($${ "order_id" : "9", "date" : "44476", "product_id" : "7", "cost_per" : "140", "quantity" : "2", "amount" : "280", "tax" : "16.8", "total_charged" : "296.8" }$$) union all
  select 9000109,'8/11/2020',parse_json($${ "order_id" : "10", "date" : "43633", "product_id" : "6", "cost_per" : "200", "quantity" : "5", "amount" : "1000", "tax" : "60", "total_charged" : "1060" }$$) union all
  select 9000110,'10/4/2019',parse_json($${ "order_id" : "11", "date" : "43779", "product_id" : "2", "cost_per" : "50", "quantity" : "3", "amount" : "150", "tax" : "9", "total_charged" : "159" }$$) union all
  select 9000111,'9/6/2020',parse_json($${ "order_id" : "12", "date" : "44472", "product_id" : "9", "cost_per" : "750", "quantity" : "2", "amount" : "1500", "tax" : "90", "total_charged" : "1590" }$$) union all
  select 9000112,'11/14/2019',parse_json($${ "order_id" : "13", "date" : "43926", "product_id" : "6", "cost_per" : "200", "quantity" : "3", "amount" : "600", "tax" : "36", "total_charged" : "636" }$$) union all
  select 9000113,'7/16/2020',parse_json($${ "order_id" : "14", "date" : "43480", "product_id" : "4", "cost_per" : "40", "quantity" : "4", "amount" : "160", "tax" : "9.6", "total_charged" : "169.6" }$$) union all
  select 9000114,'9/4/2021',parse_json($${ "order_id" : "15", "date" : "44027", "product_id" : "10", "cost_per" : "250", "quantity" : "5", "amount" : "1250", "tax" : "75", "total_charged" : "1325" }$$) union all
  select 9000115,'2/11/2020',parse_json($${ "order_id" : "16", "date" : "44064", "product_id" : "1", "cost_per" : "1500", "quantity" : "2", "amount" : "3000", "tax" : "180", "total_charged" : "3180" }$$) union all
  select 9000116,'9/10/2021',parse_json($${ "order_id" : "17", "date" : "43802", "product_id" : "8", "cost_per" : "150", "quantity" : "5", "amount" : "750", "tax" : "45", "total_charged" : "795" }$$) union all
  select 9000117,'1/26/2019',parse_json($${ "order_id" : "18", "date" : "44530", "product_id" : "6", "cost_per" : "200", "quantity" : "5", "amount" : "1000", "tax" : "60", "total_charged" : "1060" }$$) union all
  select 9000118,'6/19/2020',parse_json($${ "order_id" : "19", "date" : "44539", "product_id" : "9", "cost_per" : "750", "quantity" : "5", "amount" : "3750", "tax" : "225", "total_charged" : "3975" }$$) union all
  select 9000119,'5/23/2020',parse_json($${ "order_id" : "20", "date" : "43469", "product_id" : "10", "cost_per" : "250", "quantity" : "4", "amount" : "1000", "tax" : "60", "total_charged" : "1060" }$$) union all
  select 9000120,'8/2/2019',parse_json($${ "order_id" : "21", "date" : "43473", "product_id" : "3", "cost_per" : "225", "quantity" : "4", "amount" : "900", "tax" : "54", "total_charged" : "954" }$$) union all
  select 9000121,'11/24/2019',parse_json($${ "order_id" : "22", "date" : "43501", "product_id" : "4", "cost_per" : "40", "quantity" : "1", "amount" : "40", "tax" : "2.4", "total_charged" : "42.4" }$$) union all
  select 9000122,'8/26/2021',parse_json($${ "order_id" : "23", "date" : "43614", "product_id" : "10", "cost_per" : "250", "quantity" : "2", "amount" : "500", "tax" : "30", "total_charged" : "530" }$$) union all
  select 9000123,'6/23/2019',parse_json($${ "order_id" : "24", "date" : "43726", "product_id" : "2", "cost_per" : "50", "quantity" : "2", "amount" : "100", "tax" : "6", "total_charged" : "106" }$$) union all
  select 9000124,'8/28/2021',parse_json($${ "order_id" : "25", "date" : "44011", "product_id" : "5", "cost_per" : "15", "quantity" : "3", "amount" : "45", "tax" : "2.7", "total_charged" : "47.7" }$$) ;

-------------------------------------------
-- create roles
-------------------------------------------

USE ROLE ACCOUNTADMIN;

GRANT USAGE ON DATABASE RAW TO ROLE dbt_dev_role;
grant usage on database RAW to role dbt_dev_role;
grant usage on schema RAW.TECH_STORE to role dbt_dev_role;
grant usage on schema RAW.PAYMENT_APP to role dbt_dev_role;
grant select on all tables in schema RAW.TECH_STORE to role dbt_dev_role;
grant select on all tables in schema RAW.PAYMENT_APP to role dbt_dev_role;


GRANT ALL ON DATABASE DBT_DEV TO ROLE dbt_dev_role;
GRANT ALL ON DATABASE DBT_PROD TO ROLE dbt_prod_role;
GRANT ALL ON ALL SCHEMAS IN DATABASE DBT_DEV TO ROLE dbt_dev_role;
GRANT ALL ON ALL SCHEMAS IN DATABASE DBT_PROD TO ROLE dbt_prod_role;

use role accountadmin;
grant role dbt_dev_role to role dbt_prod_role;
