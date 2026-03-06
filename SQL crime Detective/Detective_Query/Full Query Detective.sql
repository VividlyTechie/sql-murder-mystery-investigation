WITH official_crime_scene_report AS (
	-- Retrieve the official crime scene report for the murder
	SELECT 
		* 
	FROM crime_scene_report
	WHERE crime_type = 'murder'
	AND crime_date = '2018-01-15'
	AND city = 'SQL City'
),

witness_details AS (
-- Find the first witness (last house on Northwestern Dr) and the second witness (Annabel on Franklin Ave)
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
	AND address_street_name = 'Franklin Ave')
),

witness_interview_transcript AS (
-- Retrieve the interview transcripts for the two witnesses
	SELECT 
		* 
	FROM interview
	WHERE person_id IN (
		SELECT 
			person_id 
		FROM witness_details
		)
),


killer_information AS (
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
		AND dl.plate_number ILIKE '%H42W%'	 	-- Witness 1: license plate
),


killer_interview_transcript AS (
-- Get the interview transcript from the captured killer, Jeremy Bowers
	SELECT 
		* 
	FROM interview
	WHERE person_id IN (
		SELECT 
			person_id 
		FROM killer_information
		)
),

mastermind_details AS (
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
	HAVING COUNT(fc.event_id)=3 			-- Attended 3 times in December
)

--Displaying the Witness
SELECT 
    'Witness' AS category,
	person_id AS person_id,
	address_street_name  AS category_info
FROM witness_details

UNION ALL

--Displaying the Killer
SELECT 
    'Killer' AS category,
	person_id AS person_id,
	('Membership: ' || membership_id || ','  || '  Plate_number: ' || plate_number) AS category_info
FROM killer_information

UNION ALL

--Displaying the Mastermind
SELECT 
    'Mastermind' AS category,
	person_id AS person_id,
	('hair_color: ' || hair_color || ','  || '  car_info:' || car_make || ' ' || car_model ) AS category_info
FROM mastermind_details;



