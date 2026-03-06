--QUERY 1 : Retrieve the official crime scene report for the murder
SELECT 
	* 
FROM crime_scene_report
WHERE crime_type = 'murder'
AND crime_date = '2018-01-15'
AND city = 'SQL City';



--QUERY 2 : Find the first witness (last house on Northwestern Dr) and the second witness (Annabel on Franklin Ave)

-- Find first witness: last house on Northwestern Dr

(SELECT
	person_id,
	name,
	address_number, 
	address_street_name
FROM person
WHERE address_street_name  = 'Northwestern Dr'
ORDER BY address_number DESC 	--Gets the highest address number(ie last house)
LIMIT 1)

UNION

-- Finds second witness: Annabel on Franklin Ave
(SELECT
	person_id,
	name,
	address_number, 
	address_street_name
FROM person
WHERE name ILIKE '%Annabel%' 
AND address_street_name = 'Franklin Ave'); 



--Query 3: Retrieve the interview transcripts for the two witnesses
SELECT
	* 
FROM interview
WHERE person_id in(14887, 16371);



/*Query 4: identify the killer by cross-referencing the gym membership(from Morty-witness 1), 
check-in date(from Annabel-Witness 2) and driver's license(from Morty-witness 1).*/

SELECT 
	p.person_id,
	p.name, 
	gm.membership_id,
	dl.plate_number
FROM drivers_license AS dl             --Join Relevant Tables
JOIN person AS p 
	ON dl.license_id = p.license_id              
JOIN get_fit_now_member AS gm 	  
	ON p.person_id = gm.person_id	  
JOIN get_fit_now_check_in AS gc 
	ON gc.membership_id = gm.membership_id		
WHERE gm.membership_id ILIKE '48Z%'			-- Witness 1: Gym bag ID
	AND gm.membership_status = 'gold'		-- Witness 1: gold member
	AND gc.check_in_date = '2018-01-09'	 	-- Witness 2: saw at gym
	AND dl.plate_number ILIKE '%H42W%';	 	-- Witness 1: license plate




--Query 5: Get the interview transcript from the captured killer, Jeremy Bowers
SELECT 
	* 
FROM interview
WHERE person_id = 67318;



/*Query 6: Find the mastermind based on the description from Jeremy Bowers' testimony
(rich lady, red hair, 65-67 height,Tesla model S, Attended SQL Symphony Concert 3 times in december)*/
SELECT 
	p.person_id,
	p.name,
	dl.gender, 
	dl.hair_color,
	dl.car_make, 
	dl.car_model
FROM drivers_license AS dl  			--Relevant table Joins
JOIN person AS p
	ON dl.license_id = p.license_id
JOIN facebook_event_checkin AS fc
	ON fc.person_id = p.person_id
WHERE dl.hair_color= 'red'  			--Mastermind Description
	AND dl.height BETWEEN 65 AND 67
	AND dl.gender = 'female'
	AND dl.car_make = 'Tesla'
	AND dl.car_model = 'Model S'
	AND fc.event_name = 'SQL Symphony Concert'
	AND fc.event_date::text LIKE '2017-12%'
GROUP BY 1,2,3,4,5,6
HAVING COUNT(fc.event_id) = 3;  			-- Attended 3 times in December


