
create table suppliers(
	supplier_id serial,
	supplier_name varchar(150),
	contact_person varchar(100),
	phone_number varchar(20),
	email  varchar(150),
	country varchar(200),
	created_at  timestamp
);

select * from suppliers;

select * 
from suppliers
where lo = 'India'


create table purchase_orders(
po_id serial primary key,
supplier_id int not null,
po_date date not null,
expected_date date check (expected_date is null or  expected_date >= po_date), 
status varchar(20) not null default 'pending',
total_amount numeric(10,2) not null default 0.00  check (total_amount >= 0),
created_at timestamp not null default current_timestamp,
foreign key(supplier_id) 
references suppliers(supplier_id)
);

select * from purchase_orders;

INSERT INTO purchase_orders
(supplier_id, po_date, expected_date, status, total_amount)
VALUES
(1, '2025-01-05', '2025-01-12', 'Pending',   1500.00),
(2, '2025-01-06', '2025-01-15', 'Approved', 3200.50),
(3, '2025-01-07', NULL,         'Pending',    750.00),
(1, '2025-01-08', '2025-01-20', 'Shipped',  4800.00),
(4, '2025-01-09', '2025-01-18', 'Delivered',2100.75),
(2, '2025-01-10', '2025-01-25', 'Approved',  999.99),
(5, '2025-01-11', NULL,         'Pending',    300.00),
(3, '2025-01-12', '2025-01-22', 'Cancelled',   0.00);

create table purchase_order_items (
    po_item_id serial primary key,
    po_id int not null unique,
    product_id int not null unique,
    quantity int not null default 1 check (quantity > 0),
    unit_price numeric(10,2) not null check (unit_price >= 0),
    created_at timestamp default current_timestamp,
	foreign key (po_id) references purchase_orders(po_id)
);

select * from purchase_order_items;

insert into purchase_order_items (po_id, product_id, quantity, unit_price)
values
(1, 1001, 2, 250.00),
(2, 1002, 1, 120.50),
(3, 1003, 5, 75.00),
(4, 1004, 3, 999.99),
(5, 1005, 1, 45.75);

create table inventory (
    inventory_id serial primary key,
    warehouse_id int not null unique,
    product_id int not null unique,
    quantity_on_hand int not null default 0 check (quantity_on_hand >= 0),
    reorder_level int not null default 10 check (reorder_level >= 0),
    last_updated timestamp default current_timestamp,
	foreign key (warehouse_id) references warehouses(warehouse_id)
);

select * from inventory;

insert into inventory (warehouse_id, product_id, quantity_on_hand, reorder_level)
values
(1, 102, 20, 5),
(2, 104, 100, 15);

select * from warehouses;

CREATE TABLE sales_orders (
    sales_order_id serial primary key,
    customer_id int not null,
    order_date date not null,
    status varchar(50) not null default 'Pending',
    total_amount numeric(12,2) not null default 0.00 check (total_amount >= 0),
    created_at timestamp default current_timestamp,
    foreign key(customer_id) references customers(customer_id)
);

insert into sales_orders(customer_id, order_date, status, total_amount)
values
(1, '2025-01-10', 'Pending', 2500.00),
(2, '2025-01-12', 'Completed', 4800.50),
(3, '2025-01-15', 'Cancelled', 0.00),
(1, '2025-01-18', 'Completed', 1250.75),
(4, '2025-01-20', 'Pending', 3200.00);

select * from  sales_orders;
select * from customers;

INSERT INTO customers (customer_name, phone_number, email, city, country)
VALUES
('Amit Sharma', '9876543210', 'amit.sharma@gmail.com', 'Mumbai', 'India'),
('Priya Verma', '9123456789', 'priya.verma@gmail.com', 'Delhi', 'India'),
('Rahul Mehta', '9988776655', 'rahul.mehta@gmail.com', 'Ahmedabad', 'India'),
('Sneha Kulkarni', '9012345678', 'sneha.k@gmail.com', 'Pune', 'India'),
('Anjali Singh', '9090909090', 'anjali.singh@gmail.com', 'Bangalore', 'India');

create table sales_order_items (
    so_item_id serial primary key,
    sales_order_id int not null unique,
    product_id int not null unique,
    quantity int not null check (quantity > 0),
    unit_price numeric(10,2) not null check (unit_price >= 0),
    created_at timestamp default current_timestamp ,
	foreign key (sales_order_id) references sales_orders(sales_order_id)
);

insert into sales_order_items (sales_order_id, product_id, quantity, unit_price)
values
(6, 101, 2, 499.99),
(7, 102, 1, 1299.50),
(8, 103, 5, 199.00),
(9, 104, 3, 349.75),
(10, 105, 4, 89.99);

select * from sales_order_items;

create table shipments (
    shipment_id serial primary key,
    sales_order_id int not null,
    warehouse_id int not null,
    shipment_date date not null,
    delivery_date date check (delivery_date is null or delivery_date >= shipment_date),
    shipment_status varchar(50) not null default 'Created',
    tracking_number varchar(100) UNIQUE,
    created_at timestamp default current_timestamp,
	foreign key(sales_order_id) references sales_orders(sales_order_id),
	foreign key(warehouse_id)references warehouses(warehouse_id)
);
insert into shipments 
(sales_order_id, warehouse_id, shipment_date, delivery_date, shipment_status, tracking_number)
values
(6, 1, '2024-12-01', '2024-12-05', 'Delivered', 'TRK10001'),
(7, 2, '2024-12-03', '2024-12-07', 'In Transit', 'TRK10002'),
(8, 1, '2024-12-04', null, 'Created', 'TRK10003'),
(9, 1, '2024-12-05', '2024-12-10', 'Delivered', 'TRK10004'),
(10, 2, '2024-12-06', null, 'In Transit', 'TRK10005');
select * from shipments;
select * from warehouses
select * from sales_orders


1.select po.po_id,po.po_date,po.status,s.supplier_name
from purchase_orders po
inner join suppliers s
on po.supplier_id = s.supplier_id
order by po.po_id;

2.select c.customer_name,so.sales_order_id,so.order_date
from customers c
left join sales_orders so
on c.customer_id = so.sales_order_id
order by c.customer_id;

3.select so.sales_order_id,so.order_date,c.customer_name
from customers c
right join sales_orders so
on c.customer_id = so.customer_id
order by so.sales_order_id;

4.select s.supplier_name,w.warehouse_name
from suppliers s
full outer join warehouses w
on s.supplier_id = w.supplier_id
order by  s.supplier_name;

5.select so.sales_order_id,so.order_date,sh.shipment_date,sh.shipment_status
from sales_orders so
inner join shipments sh
on so.sales_order_id = sh.sales_order_id
order by so.sales_order_id;

6. select w.warehouse_name,i.product_id,i.quantity_on_hand
from warehouses w
left join inventory i
on w.warehouse_id = i.warehouse_id;

7.select po.po_id, pi.po_item_id
from purchase_orders po
full outer join purchase_order_items pi
on po.po_id = pi.po_id;

8.select c.customer_name,p.product_id,p.quantity
from customers c
inner join purchase_order_items p
on c.customer_id = c.customer_id;

9.select s.supplier_name,po.po_id,po.status
from suppliers s
left join purchase_orders po
on s.supplier_id = po.supplier_id;

10.select w.warehouse_name,inv.product_id
from inventory inv 
right join warehouses w
on inv.warehouse_id = w.warehouse_id;

11.select c.customer_name,s.supplier_name
from customers c
full outer join suppliers s
on c.customer_id = s.supplier_id;

12.select s.shipment_id,w.warehouse_name,s.shipment_status
from shipments s
inner join warehouses w
on s.warehouse_id = w.warehouse_id;

13.select so.sales_order_id,s.shipment_date
from sales_orders so
left join shipments s
on so.sales_order_id = s.sales_order_id;

14.select po.po_id,s.supplier_name
from suppliers s
right join purchase_orders po
on po.supplier_id = s.supplier_id;

15.select so.sales_order_id,po.po_id
from sales_orders so
full outer join purchase_orders po
on so.sales_order_id = po.po_id;

16. select i.product_id,poi.unit_price
from inventory i
inner join purchase_order_items poi
on i.product_id = poi.product_id;

17.select c.customer_name,s.shipment_status
from customers c
left join  shipments s
on c.customer_id = s.customer_id;

18. select w.warehouse_name,s.shipment_status
from shipments s
right join warehouses w
on s.warehouse_id = w.warehouse_id;

19.select coalesce(i.product_id, soi.product_id) as product_id,soi.quantity
from inventory i
full outer join sales_order_items soi
on i.product_id = soi.product_id;

20.select poi.po_item_id,poi.po_id,po.po_date,po.status
from purchase_order_items poi
inner join purchase_orders po
on poi.po_id = po.po_id;


create table orders(
order_id int,
customer varchar(20),
region varchar(10),
amount int
);

insert into orders
values
(1, 'C1',  'North', 500),
(2, 'C2',  'North', 700),
(3, 'C3',  'North', 700),
(4, 'C4',  'South', 300),
(5, 'C5',  'South', 600),
(6, 'C6',  'South', 900),
(7, 'C7',  'East',  400),
(8, 'C8',  'East',  400),
(9, 'C9',  'West',  800),
(10,'C10', 'West', 1000);

select * from orders

select sum(amount) from orders;
select avg(amount) from orders;
select max(amount) from orders;
select min(amount) from orders;
select count(*) from orders;
select region, sum(amount) from orders group by region; 
select region, avg(amount) from orders group by region;
select region, count(amount) from orders group by region;
select region, max(amount) from orders group by region;
select region, min(amount) from orders group by region;
select row_number() over (order by amount asc) from orders;
select rank() over (order by amount desc) from orders;
select dense_rank() over (order by amount desc) from orders;
select row_number() over (partition by region order by amount asc ) from orders;
select rank() over (partition by region order by amount desc) from orders;
select dense_rank() over (partition by region order by amount desc) from orders;





