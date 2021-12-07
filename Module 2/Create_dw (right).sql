-- CREATING SCHEMAS & LOAD DATA to ANALYTICS DB

create schema dw;


-- CALENDAR

DROP TABLE if exists dw.calendar_dim cascade;

CREATE TABLE dw.calendar_dim
(
 date_dim_id date NOT NULL,
 year        int NOT NULL,
 quarter     varchar(10) NOT NULL,
 month       int NOT NULL,
 week        int NOT NULL,
 week_day    int NOT NULL,
 CONSTRAINT PK_calendar PRIMARY KEY ( date_dim_id )
);

	-- insert calendar using a script
INSERT INTO dw.calendar_dim
SELECT
	datum AS date_dim_id,
	EXTRACT(ISOYEAR FROM datum) AS year,
    	CASE
           WHEN EXTRACT(QUARTER FROM datum) = 1 THEN 'First'
           WHEN EXTRACT(QUARTER FROM datum) = 2 THEN 'Second'
           WHEN EXTRACT(QUARTER FROM datum) = 3 THEN 'Third'
           WHEN EXTRACT(QUARTER FROM datum) = 4 THEN 'Fourth'
		END AS quarter,
	EXTRACT(MONTH FROM datum) AS month,
	EXTRACT(WEEK FROM datum) AS week,
	EXTRACT(ISODOW FROM datum) AS week_day
	-- only for date from source data
FROM (select order_date datum from stg.orders union select ship_date from stg.orders) as dt
order by 1;

	-- for right calendar sequense
/*
FROM (SELECT '1970-01-01'::DATE + SEQUENCE.DAY AS datum
      FROM GENERATE_SERIES(0, 29219) AS SEQUENCE (DAY)
      GROUP BY SEQUENCE.DAY) DQ
order by 1;
*/

select * from calendar_dim
where "year" = 2017;
select order_date from stg.orders;




-- GEOGRAPHY

DROP TABLE if exists dw.geography_dim cascade;

CREATE TABLE dw.geography_dim
(
 geo_id      integer NOT NULL,
 country     varchar(50) NOT NULL,
 city        varchar(50) NOT NULL,
 "state"       varchar(50) NOT NULL,
 region      varchar(50) NOT NULL,
 postal_code varchar(6) NULL,							-- can't be integer, we lost first 0 --VARCHAR !!!! also we have 1 row without postal code (Borlington)
 CONSTRAINT PK_geographical PRIMARY KEY ( geo_id )
);

	-- insert geoinformation
	insert into dw.geography_dim
	select 100+row_number() over(), country, city, state, region, postal_code
	from (select distinct country, region, city, state, postal_code from stg.orders where postal_code is not NULL) as g;




-- CUSTOMER

DROP TABLE if exists dw.customer cascade;

CREATE TABLE dw.customer
(
 cst_id integer not null,
 customer_id   varchar(50) NOT NULL,
 customer_name varchar(50) NOT NULL,
 CONSTRAINT PK_orders PRIMARY KEY ( cst_id )
);

	-- insert customer
	insert into dw.customer
	select 100+row_number() over(), customer_id, customer_name
		from (
			select distinct customer_id, customer_name
			from stg.orders o) ood;

select * from dw.customer c ;




-- PEOPLE

DROP TABLE if exists dw.people cascade;

CREATE TABLE dw.people
(
 person_id integer NOT NULL,
 person    varchar(50) NOT NULL,
 region    varchar(50) NOT NULL,
 CONSTRAINT PK_people PRIMARY KEY ( person_id )
);

	-- insert people
	insert into dw.people 
	select 100+row_number() over(), person, region
	from stg.people p ;




-- PRODUCT

DROP TABLE if exists dw.product_dim cascade;

CREATE TABLE dw.product_dim
(
 product_id				integer NOT NULL,
 product_id_dw		varchar(15) NOT NULL,
 category				varchar(50) NOT NULL,
 sub_category			varchar(50) NOT NULL,
 product_name			varchar(150) NOT NULL,
 segment				varchar(50) NOT NULL,
 CONSTRAINT PK_product PRIMARY KEY ( product_id )
);

	-- insert product_dim
	insert into dw.product_dim
	select 100+row_number() over() as product_id, product_id as product_id_dw, category, subcategory, product_name, segment
		from (select distinct product_id, category, subcategory, product_name, segment from stg.orders) d_e ;
	

select * from dw.product_dim pd ;
	
-- SHIPPING

DROP TABLE if exists dw.shipping cascade;

CREATE TABLE dw.shipping
(
 ship_id   integer NOT NULL,
 ship_mode varchar(50) NOT NULL,
 CONSTRAINT PK_table_159 PRIMARY KEY ( ship_id )
);

	-- insert unique values and generate id
	insert into dw.shipping 
	select 100+row_number() over (), ship_mode 
		from (select distinct ship_mode from stg.orders) s_m;

	


-- SALE
	
DROP table if exists dw.sale;
truncate table dw.sale ;

CREATE TABLE dw.sale
(
 sale_id     integer NOT NULL,
 order_id    varchar(14) NOT NULL,
 sales       numeric(18,4) NOT NULL,
 quantity    integer NOT NULL,
 discount    numeric(4,2) NOT NULL,
 profit      numeric(21,16) NOT NULL,
 product_id  integer NOT NULL,
 ship_id     integer NOT NULL,
 person_id   integer NOT NULL,
 cst_id		 integer NOT NULL,
 order_date  date NOT NULL,
 ship_date   date NOT NULL,
 geo_id      integer NOT NULL,
 CONSTRAINT PK_sales PRIMARY KEY ( sale_id ),
 CONSTRAINT FK_133 FOREIGN KEY ( product_id ) REFERENCES dw.product_dim ( product_id ),
 CONSTRAINT FK_162 FOREIGN KEY ( ship_id ) REFERENCES dw.shipping ( ship_id ),
 CONSTRAINT FK_175 FOREIGN KEY ( order_date ) REFERENCES dw.calendar_dim ( date_dim_id ),
 CONSTRAINT FK_195 FOREIGN KEY ( person_id ) REFERENCES dw.people ( person_id ),
 CONSTRAINT FK_198 FOREIGN KEY ( cst_id ) REFERENCES dw.customer ( cst_id ),
 CONSTRAINT FK_213 FOREIGN KEY ( ship_date ) REFERENCES dw.calendar_dim ( date_dim_id ),
 CONSTRAINT FK_216 FOREIGN KEY ( geo_id ) REFERENCES dw.geography_dim ( geo_id )
);
CREATE INDEX fkIdx_134 ON dw.sale
(product_id);
CREATE INDEX fkIdx_163 ON dw.sale
(ship_id);
CREATE INDEX fkIdx_176 ON dw.sale
(order_date);
CREATE INDEX fkIdx_196 ON dw.sale
(person_id);
CREATE INDEX fkIdx_199 ON dw.sale
(cst_id);
CREATE INDEX fkIdx_214 ON dw.sale
(ship_date);
CREATE INDEX fkIdx_217 ON dw.sale
(geo_id);

-- insert sales with foreign keys
insert into dw.sale
select
	100+row_number() over() as sale_id,	order_id, sales, quantity, discount, profit, pd.product_id, ship_id,
	person_id, ct.cst_id, order_date, ship_date, geo_id
from stg.orders o
	inner join dw.shipping sh 		on o.ship_mode = sh.ship_mode 
	inner join dw.geography_dim gp on o.country = gp.country and o.city = gp.city and o.state = gp.state and o.postal_code = int4(gp.postal_code)
	inner join dw.product_dim pd 	on o.product_name = pd.product_name and o.category = pd.category and o.subcategory = pd.sub_category and o.product_id = pd.product_id_dw and o.segment = pd.segment
	inner join dw.customer ct 		on o.customer_id = ct.customer_id and o.customer_name = ct.customer_name
	inner join stg.people p 		on o.region = p.region
	inner join dw.people sp 		on p.person = sp.person 
	inner join dw.calendar_dim cd 	on o.ship_date = cd.date_dim_id 
	inner join dw.calendar_dim cd_2 on o.order_date = cd_2.date_dim_id ;



---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

-- QUALITY CHECK
select distinct postal_code, city, state
from stg.orders o 
where postal_code is null or city is null or state is null;


-- UPDATE MISS DATA

-- City 'Burlington' doesn't have zip/postal code
update dw.geography_dim
set postal_code = '05401'
where city = 'Burlington' and postal_code is null;
-- also update source data
update stg.orders 
set postal_code = '05401'
where city = 'Burlington' and postal_code is null;

-- you must get 9 994 row
select count(*) from stg.orders o ;		-- 9 994
select count(*) from dw.sale;