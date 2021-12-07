select * from stg_etl.orders o 
limit 20;


select * from dw_etl.product_dim pd ;


update stg_etl.orders
set update_date_var = current_timestamp 
where product_id = 'OFF-AR-10002833' 
	and product_name = 'Newell 322'
	and category = 'Office Supplies'
	and sub_category = 'Art'
	and segment = 'Consumer';




product_id		product_name	category			sub_category	segment
OFF-AR-10002833	Newell 322		Office Supplies		Art				Consumer


--update_time		update_date_var					update_date_fix	flagfield
--3199924			2021/11/27 21:00:47.833000000	2021/11/27 21:00:44.698000000
