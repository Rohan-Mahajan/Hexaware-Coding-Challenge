create database carRental;

create table vehicle(
     vehicle_id int primary key,
	 maker varchar(20) not null,
	 model varchar(20) not null,
	 year int,
	 daily_rate decimal(10, 2) not null constraint chk_dr check (daily_rate>0),
	 status varchar(20) constraint chk_status check (status in ('available', 'notAvailable')),
	 passenger_capacity int constraint chk_capa check (passenger_capacity >0),
	 engine_capacity int constraint chk_encapa check (engine_capacity >0)
);

create table customer(
     customer_id int primary key,
	 first_name varchar(20) not null,
	 last_name varchar(20) not null,
	 email varchar(30) unique not null,
	 phone_number varchar(20) not null
);

create table lease(
     lease_id int primary key,
	 vehicle_id int not null,
	 customer_id int not null,
	 start_date date not null,
	 end_date date not null,
	 type varchar(20) constraint chk_type check(type in ('DailyLease', 'MonthlyLease')),
	 constraint fk_lease_vehicle foreign key (vehicle_id)
	 references vehicle(vehicle_id) 
	 on delete cascade
	 on update cascade,
	 constraint fk_lease_customer foreign key (customer_id)
	 references customer(customer_id) 
	 on delete cascade
	 on update cascade,
);

create table payment(
     payment_id int primary key,
	 lease_id int not null,
	 payment_date date not null,
	 amount decimal(10, 2) not null check(amount>0),
	 constraint fk_payment_lease foreign key(lease_id)
	 references lease(lease_id)
	 on delete cascade
	 on update cascade
);

-- Insert data into vehicle table with provided values
insert into vehicle (vehicle_id, maker, model, year, daily_rate, status, passenger_capacity, engine_capacity) values
(1, 'Toyota', 'Camry', 2022, 50.00, 'available', 4, 1450),
(2, 'Honda', 'Civic', 2023, 45.00, 'available', 7, 1500),
(3, 'Ford', 'Focus', 2022, 48.00, 'notAvailable', 4, 1400),
(4, 'Nissan', 'Altima', 2023, 52.00, 'available', 7, 1200),
(5, 'Chevrolet', 'Malibu', 2022, 47.00, 'available', 4, 1800),
(6, 'Hyundai', 'Sonata', 2023, 49.00, 'notAvailable', 7, 1400),
(7, 'BMW', '3 Series', 2023, 60.00, 'available', 7, 2499),
(8, 'Mercedes', 'C-Class', 2022, 58.00, 'available', 8, 2599),
(9, 'Audi', 'A4', 2022, 55.00, 'notAvailable', 4, 2500),
(10, 'Lexus', 'ES', 2023, 54.00, 'available', 4, 2500);

INSERT INTO customer (customer_id, first_name, last_name, email, phone_number) VALUES
(1, 'John', 'Doe', 'johndoe@example.com', '555-555-5555'),
(2, 'Jane', 'Smith', 'janesmith@example.com', '555-123-4567'),
(3, 'Robert', 'Johnson', 'robert@example.com', '555-789-1234'),
(4, 'Sarah', 'Brown', 'sarah@example.com', '555-456-7890'),
(5, 'David', 'Lee', 'david@example.com', '555-987-6543'),
(6, 'Laura', 'Hall', 'laura@example.com', '555-234-5678'),
(7, 'Michael', 'Davis', 'michael@example.com', '555-876-5432'),
(8, 'Emma', 'Wilson', 'emma@example.com', '555-432-1098'),
(9, 'William', 'Taylor', 'william@example.com', '555-321-6547'),
(10, 'Olivia', 'Adams', 'olivia@example.com', '555-765-4321');


INSERT INTO lease (lease_id, vehicle_id, customer_id, start_date, end_date, type) VALUES
(1, 1, 1, '2023-01-01', '2023-01-05', 'DailyLease'),
(2, 2, 2, '2023-02-15', '2023-02-28', 'MonthlyLease'),
(3, 3, 3, '2023-03-10', '2023-03-15', 'DailyLease'),
(4, 4, 4, '2023-04-20', '2023-04-30', 'MonthlyLease'),
(5, 5, 5, '2023-05-05', '2023-05-10', 'DailyLease'),
(6, 4, 3, '2023-06-15', '2023-06-30', 'MonthlyLease'),
(7, 7, 7, '2023-07-01', '2023-07-10', 'DailyLease'),
(8, 8, 8, '2023-08-12', '2023-08-15', 'MonthlyLease'),
(9, 3, 3, '2023-09-07', '2023-09-10', 'DailyLease'),
(10, 10, 10, '2023-10-10', '2023-10-31', 'MonthlyLease');

INSERT INTO payment (payment_id, lease_id, payment_date, amount) VALUES
(1, 1, '2023-01-03', 200.00),
(2, 2, '2023-02-20', 1000.00),
(3, 3, '2023-03-12', 75.00),
(4, 4, '2023-04-25', 900.00),
(5, 5, '2023-05-07', 60.00),
(6, 6, '2023-06-18', 1200.00),
(7, 7, '2023-07-03', 40.00),
(8, 8, '2023-08-14', 1100.00),
(9, 9, '2023-09-09', 80.00),
(10, 10, '2023-10-25', 1500.00);


--Update the daily rate for a Mercedes car to 68.

update vehicle 
set daily_rate = 68
where maker = 'Mercedes';

select * from vehicle;

--Delete a specific customer and all associated leases and payments.
delete from customer
where customer_id = 5;

select * from customer;

--Rename the "paymentDate" column in the Payment table to "transactionDate".

exec sp_rename 'payment.payment_date', 'transaction_date', 'column';
select * from payment;

--Find a specific customer by email.

select * from customer
where email = 'robert@example.com';

--Get active leases for a specific customer.

select * from lease
where customer_id = 6 and end_date>=getdate();

--Find all payments made by a customer with a specific phone number.

select concat(c.first_name,' '+c.last_name) as customer_name, c.phone_number, p.transaction_date
from lease l
join customer c on l.customer_id = c.customer_id
join payment p on l.lease_id = p.lease_id
where c.phone_number = '555-555-5555'
group by concat(c.first_name,' '+c.last_name), c.phone_number, p.transaction_date;

--Calculate the average daily rate of all available cars.

select avg(daily_rate) as avg_rate from vehicle;

--Find the car with the highest daily rate.

select * from vehicle
where daily_rate = (select max(daily_rate) from vehicle);

--Retrieve all cars leased by a specific customer.

select v.vehicle_id, v.maker, v.model, c.first_name
from lease l
inner join vehicle v on l.vehicle_id = v.vehicle_id
inner join customer c on l.customer_id = c.customer_id
where c.first_name = 'Robert'
group by v.maker, v.model, v.vehicle_id, c.first_name;

--. Find the details of the most recent lease.

select * from lease
order by start_date
offset (select count(*) from lease) -1 rows;

--List all payments made in the year 2023.

select * from payment
where year(transaction_date) = 2023;

--Retrieve customers who have not made any payments.

select c.customer_id, concat(c.first_name, ' '+c.last_name) as customer_name
from customer c
where not exists(
     select 1 from lease l
	 join payment p on l.lease_id = p.lease_id
	 where l.customer_id = c.customer_id
);

--Retrieve Car Details and Their Total Payments.

select v.vehicle_id, v.maker, v.model, sum(p.amount) as total_payments
from lease l
join vehicle v on l.vehicle_id = v.vehicle_id
join payment p on l.lease_id = p.lease_id
group by v.vehicle_id, v.maker, v.model;

-- Calculate Total Payments for Each Customer.

select concat(c.first_name, ' '+c.last_name) as customer_name, sum(p.amount) as total_amount
from lease l
join customer c on l.customer_id = c.customer_id
join payment p on l.lease_id = p.lease_id
group by concat(c.first_name, ' '+c.last_name);

--List Car Details for Each Lease.

select l.lease_id, v.vehicle_id, v.maker, v.model, l.type
from vehicle v
join lease l on v.vehicle_id = l.vehicle_id;

--Retrieve Details of Active Leases with Customer and Car Information.

-- Inserting new leases with some reecent leases
insert into lease (lease_id, vehicle_id, customer_id, start_date, end_date, type) values
(11, 9, 6, '2024-09-11', '2024-09-15', 'DailyLease'),
(12, 6, 9, '2024-09-20', '2024-09-25', 'DailyLease');

-- Inserting corresponding payment data for these recent leases
insert into payment (payment_id, lease_id, transaction_date, amount) values
(11, 11, '2024-09-13', 275.00),
(12, 12, '2024-09-22', 225.00);

--query
select v.vehicle_id, c.customer_id, l.lease_id
from lease l
join customer c on l.customer_id = c.customer_id
join vehicle v on l.vehicle_id = v.vehicle_id
where l.end_date> getdate();

--Find the Customer Who Has Spent the Most on Leases.

select top 1 
     l.customer_id, 
	 concat(c.first_name, ' '+c.last_name) as customer_name, 
	 sum(p.amount) as pay_amounts
from lease l
join payment p on l.lease_id = p.lease_id
join customer c on l.customer_id = c.customer_id
group by l.customer_id, concat(c.first_name, ' '+c.last_name)
order by pay_amounts desc;

--List All Cars with Their Current Lease Information.

select v.vehicle_id, v.maker, v.model, l.type
from vehicle v
join lease l on v.vehicle_id = l.vehicle_id
order by v.vehicle_id;
