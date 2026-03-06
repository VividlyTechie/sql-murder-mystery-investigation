-- create table crime_scene_report 
Drop Table if exists crime_scene_report;
CREATE TABLE crime_scene_report ( 
	crime_date Date, 
	crime_type text, 
	description text, 
	city Varchar
	); 
	
-- create table drivers_license
Drop Table if exists drivers_license;
CREATE TABLE drivers_license ( 
	license_id int PRIMARY KEY, 
	age integer, 
	height integer, 
	eye_color text, 
	hair_color text, 
	gender text, 
	plate_number text, 
	car_make text, 
	car_model text
	); 

-- create table income 
Drop Table if exists income;
CREATE TABLE income ( 
	ssn CHAR(20) PRIMARY KEY, 
	annual_income integer 
	); 
	
-- create table person
Drop Table if exists person;
CREATE TABLE person ( 
	person_id integer PRIMARY KEY, 
	name varchar, 
	license_id integer, 
	address_number integer, 
	address_street_name text, 
	ssn CHAR(20) REFERENCES income (ssn), 
	FOREIGN KEY (license_id) REFERENCES drivers_license (license_id) 
	);

Drop Table if exists person_without_constraint;
CREATE TABLE person_without_constraint ( 
	person_id integer, 
	name varchar, 
	license_id integer, 
	address_number integer, 
	address_street_name text, 
	ssn CHAR(20)  
	);
	
	-- create table facebook_event_checkin 
Drop Table if exists facebook_event_checkin;
CREATE TABLE facebook_event_checkin ( 
	person_id int, 
	event_id int, 
	event_name varchar, 
	event_date Date, 
	FOREIGN KEY (person_id) REFERENCES person(person_id) 
	); 
	
-- create table get_fit_now_member
Drop Table if exists get_fit_now_member;
CREATE TABLE get_fit_now_member ( 
	membership_id text PRIMARY KEY, 
	person_id integer, 
	name text, 
	membership_start_date Date, 
	membership_status text, 
	FOREIGN KEY (person_id) REFERENCES person(person_id) 
	); 
	
-- create table get_fit_now_check_in 
DROP TABLE IF EXISTS get_fit_now_check_in;
CREATE TABLE get_fit_now_check_in ( 
	membership_id text, 
	check_in_date Date, 
	check_in_time integer, 
	check_out_time integer, 
	FOREIGN KEY (membership_id) 
	REFERENCES get_fit_now_member(membership_id)
	); 
	
-- create table interview 
Drop Table if exists interview;
CREATE TABLE interview ( 
	person_id integer, 
	transcript text, 
	FOREIGN KEY (person_id) REFERENCES person(person_id)
	);

SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';
