--QUERY 1 : Retrieve the official crime scene report for the murder
SELECT 
	* 
FROM crime_scene_report
WHERE crime_type = 'murder'
AND crime_date = '2018-01-15'
AND city = 'SQL City'


-- Murder Description : "Security footage shows that there were 2 witnesses. 
-- The first witness lives at the last house on ""Northwestern Dr"". 
-- The second witness, named Annabel, lives somewhere on ""Franklin Ave""."

-- Find the first witness (last house on Northwestern Dr) and the second witness (Annabel on Franklin Ave)

-- Find the first witness (last house on Northwestern Dr) and the second witness (Annabel on Franklin Ave)

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
  
 

-- Retrieve the interview transcripts for the two witnesses
SELECT
	* 
FROM interview
WHERE person_id in(14887, 16371);

/*14887- "I heard a gunshot and then saw a man run out. He had a ""Get Fit Now Gym"" bag. 
The membership number on the bag started with ""48Z"". Only gold members have those bags. 
The man got into a car with a plate that included ""H42W""."

"16371- I saw the murder happen, and I recognized the killer from my gym when
I was working out last week on January the 9th."*/
-- identify the killer by cross-referencing the gym membership, check-in date, and driver's license.
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



-- Get the interview transcript from the captured killer, Jeremy Bowers
SELECT 
	* 
FROM interview
WHERE person_id = 67318;

/*"I was hired by a woman with a lot of money. 
I don't know her name but I know she's around 5'5' (65"") or 5'7' (67'). 
She has red hair and she drives a Tesla Model S. 
I know that she attended the SQL Symphony Concert 3 times in December 2017."*/

ql
-- Find the mastermind based on the description from Jeremy Bowers' testimony
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
GROUP BY  p.person_id, p.name, dl.gender, dl.hair_color, dl.car_make, dl.car_model
HAVING COUNT(fc.event_id) = 3;  			-- Attended 3 times in December

