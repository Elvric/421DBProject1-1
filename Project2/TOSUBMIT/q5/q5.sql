/* Question 5 */

--5.1
/*Get all the clients whose subscriptions are out of date */
SELECT cid
FROM clients
EXCEPT SELECT cid
FROM subscriptions S
WHERE S.enddate > '2018-01-01'
LIMIT 50;

--5.2
/* Show how much each drug appears in prescription for the female gender*/
SELECT PC.duid, sum(Pc.quantity)
FROM prescriptions P, individuals I, prescriptioncontents Pc, drugs D
WHERE P.cid = I.cid AND I.gender = 'Female' AND Pc.pid = P.pid AND D.duid=Pc.duid
GROUP BY PC.duid
ORDER BY PC.duid
LIMIT 50;

--5.3
/*Projects infos on each drug in order sorted by price and refills (and manufacturer and quantity)*/
SELECT
	D.duid,
	D.dname,
	D.manufacturer,
	D.price,
	PC.quantity,
	PC.refills
FROM
	drugs D,
	prescriptioncontents PC
WHERE
	PC.refills > 0
	AND D.duid = PC.duid
ORDER BY
	D.dname,
	D.price,
	PC.refills,
	D.manufacturer,
	PC.quantity
LIMIT 50;

--5.4
/*Shows the average money spent on plans by clients based on gender*/
SELECT I.gender,AVG(P.price::NUMERIC) 
FROM subscriptions S, individuals I, insuranceplans P
WHERE S.planid = P.planid AND I.cid = S.cid
GROUP BY I.gender;

--5.5
/* Get adult individuals who have been reimbursed more than 20$ */
SELECT
	DISTINCT(I.birthdate),
	I.cid,
	SUM( Re.amount::NUMERIC )
FROM
	insuranceclaims IC,
	receipts R,
	individuals I,
	reimbursed Re,
	prescriptions P
WHERE
	IC.rid = R.rid
	AND Re.icid = IC.icid
	AND IC.rid = R.rid
	AND R.pid = P.pid
	AND P.cid = I.cid
	AND I.cid IN(
		SELECT
			cid
		FROM
			individuals
		WHERE
			age(current_date, I.birthdate) >= '18 years'
	)
GROUP BY
	I.cid
HAVING
	SUM( Re.amount::NUMERIC )> 20
LIMIT 50;


