--1.	Display the invoice number, the invoice date, the customer id, and the customer name for each order in the database.
SELECT invoice_num, invoice_date, customer.cust_id, cust_name
FROM invoice, customer
WHERE customer.cust_id = invoice.cust_id;

-- ^ This is called an EQUIJOIN (also INNER JOIN)
SELECT invoice_num, invoice_date, customer.cust_id, cust_name
FROM invoice INNER JOIN customer ON invoice.cust_id = customer.cust_id;

-- WEIRD OUTER JOIN (not precedence from keyword RIGHT)
SELECT invoice_num, invoice_date, customer.cust_id, cust_name
FROM invoice RIGHT OUTER JOIN customer ON invoice.cust_id = customer.cust_id;

--2.	Display the invoice number, the customer id, and the customer name for each order placed on September 12th, 2007.
SELECT invoice_num, customer.cust_id, cust_name
FROM invoice, customer
WHERE customer.cust_id = invoice.cust_id
AND invoice_date = '12-SEP-07';

--3.	Display the invoice number, the invoice date, the product id, the number of units ordered, and the line price for each line in each order.
SELECT invoice.invoice_num, invoice_date, line.prod_id, line_num_ordered, line_price	
FROM invoice, line
WHERE invoice.invoice_num = line.invoice_num;

SELECT invoice.invoice_num, invoice_date, line.prod_id, line_num_ordered, line_price	
FROM invoice INNER JOIN line ON invoice.invoice_num = line.invoice_num; 

--4.	Display the id and the name of each customer that placed an order on September 12th, 2007, using the IN operator in your query.
SELECT cust_id, cust_name
FROM customer
WHERE cust_id IN
 (
	SELECT cust_id
	FROM invoice
	WHERE invoice_date = '12-SEP-07'
 ); 

--5.	Display the id and the name of each customer that placed an order on September 12th, 2007, using the EXISTS operator in your query.
SELECT cust_id, cust_name
FROM customer
WHERE EXISTS 
(
	SELECT * 
	FROM invoice
	WHERE customer.cust_id = invoice.cust_id
	AND invoice_date = '12-SEP-07'
);

--6.	Display the id and the name of each customer that did not place an order on September 12th, 2007.   (Be careful in performing this query.)
SELECT cust_id, cust_name
FROM customer
WHERE cust_id IN
 (
	SELECT cust_id
	FROM invoice
	WHERE invoice_date != '12-SEP-07'
 ); 
 
--7.	Display the invoice number, the invoice date, the product id, the product description, and the product type for each line in each order.
SELECT invoice.invoice_num, invoice_date, line.prod_id, prod_desc, prod_type
FROM invoice, line, product
WHERE invoice.invoice_num = line.invoice_num
AND product.prod_id = line.prod_id;

--8.	Display the same data as in question 7, but order the display by product type.  Within each type, order the display by invoice number.
SELECT invoice.invoice_num, invoice_date, line.prod_id, prod_desc, prod_type
FROM invoice, line, product
WHERE invoice.invoice_num = line.invoice_num
AND product.prod_id = line.prod_id
ORDER BY prod_type, invoice.invoice_num;

--9.	Display the sales representative's id, last name, and first name of each representative who represents, at a minimum, one customer whose credit is $10,000 using a subquery.
SELECT rep_id, rep_lname, rep_fname
FROM rep
WHERE rep_id IN 
(
	SELECT rep_id
	FROM customer
 	WHERE cust_limit >= 10000
    );
 
--10.	Display the same data as in the previous question without using a subquery.
SELECT rep.rep_id, rep_lname, rep_fname
FROM rep, customer
WHERE rep.rep_id = customer.rep_id
AND cust_limit >= 10000
GROUP BY rep.rep_id;

--Better to use DISTINCT function, because we're not aggregating anything.

SELECT DISTINCT(rep.rep_id), rep_lname, rep_fname
FROM rep, customer
WHERE rep.rep_id = customer.rep_id
AND cust_limit >= 10000;

--11.	Display the id and the name of each customer with a current order for a Blender.
SELECT customer.cust_id, cust_name
FROM product, customer, line, invoice
WHERE customer.cust_id = invoice.cust_id
AND invoice.invoice_num = line.invoice_num
AND line.prod_id = product.prod_id
AND prod_desc = 'Blender';

-- Using a quadruple JOIN function.

SELECT customer.cust_id, cust_name
FROM customer JOIN invoice ON customer.cust_id = invoice.cust_id JOIN line ON invoice.invoice_num = line.invoice_num JOIN product ON line.prod_id = product.prod_id
WHERE prod_desc = 'Blender';

--12.	Display the invoice number and the invoice date for each customer order placed by Charles Appliance and Sport.
SELECT invoice_num, invoice_date
FROM invoice, customer
WHERE invoice.cust_id = customer.cust_id
AND cust_name = 'Charles Appliance and Sport';

--13.	Display the invoice number and the invoice date for each invoice that contains an Electric Range.
SELECT invoice.invoice_num, invoice_date
FROM invoice, product, line
WHERE invoice.invoice_num = line.invoice_num
AND line.prod_id = product.prod_id
AND prod_desc = 'Electric Range';

-- Using JOIN Functions

SELECT invoice.invoice_num, invoice_date
FROM invoice JOIN line ON invoice.invoice_num = line.invoice_num JOIN product ON line.prod_id = product.prod_id 
WHERE prod_desc = 'Electric Range';

--14.	Display the invoice number and the invoice date for each invoice that was either placed by Charles Appliance and Sport or whose invoice contains an Electric Range.  Use a set operation to perform this query.
SELECT invoice.invoice_num, invoice_date
FROM invoice, line
WHERE cust_id IN
(
	SELECT cust_id
	FROM customer
	WHERE cust_name = 'Charles Appliance and Sport'
)
OR invoice.invoice_num IN 
(
	SELECT invoice_num
	FROM line
	WHERE prod_id IN
	(
		SELECT prod_id
		FROM product
		WHERE prod_desc = 'Electric Range'
	)
)
GROUP BY invoice.invoice_num;

-- With DISTINCT()

SELECT DISTINCT(invoice.invoice_num), invoice_date
FROM invoice, line
WHERE cust_id IN
(
	SELECT cust_id
	FROM customer
	WHERE cust_name = 'Charles Appliance and Sport'
)
OR invoice.invoice_num IN 
(
	SELECT invoice_num
	FROM line
	WHERE prod_id IN
	(
		SELECT prod_id
		FROM product
		WHERE prod_desc = 'Electric Range'
	)
);

--15.	Display the invoice number and the invoice date for each invoice that was placed by Charles Appliance and Sport and whose invoice contains an Electric Range.  Use a set operation to perform this query.
SELECT invoice.invoice_num, invoice_date
FROM invoice, line
WHERE cust_id IN
(
	SELECT cust_id
	FROM customer
	WHERE cust_name = 'Charles Appliance and Sport'
)
AND invoice.invoice_num IN 
(
	SELECT invoice_num
	FROM line
	WHERE prod_id IN
	(
		SELECT prod_id
		FROM product
		WHERE prod_desc = 'Electric Range'
	)
)
GROUP BY invoice.invoice_num; 

--16.	Display the invoice number and the invoice date for each invoice that was placed by Charles Appliance and Sport and whose invoice does not contain an Electric Range.  Use a set operation to perform this query.
SELECT invoice.invoice_num, invoice_date
FROM invoice, line
WHERE cust_id IN
(
	SELECT cust_id
	FROM customer
	WHERE cust_name = 'Charles Appliance and Sport'
)
AND invoice.invoice_num IN 
(
	SELECT invoice_num
	FROM line
	WHERE prod_id IN
	(
		SELECT prod_id
		FROM product
		WHERE prod_desc != 'Electric Range'
	)
)
GROUP BY invoice.invoice_num;

--17.	Display the product id, the product description, the product price, and the product type for each product whose product price is greater than the price of every part in product type SG.  Be sure to correctly choose either the ALL or the ANY operator in your query.
SELECT prod_id, prod_desc, prod_price, prod_type
FROM product
WHERE prod_price > ALL (SELECT prod_price FROM product WHERE prod_type = 'SG');

--18.	Display the same attributes as in the previous question.  However, use the other of the two operators: ALL or ANY.  This version of the SQL statement provides the answer to a question.  What is that question?  Add your answer as a comment to your list file.
SELECT prod_id, prod_desc, prod_price, prod_type
FROM product
WHERE NOT (prod_price <= ANY (SELECT prod_price FROM product WHERE prod_type = 'SG'));
-- Question: Display the product id, the product description, the product price, and the product type for each product whose product price is NOT less than or equal to the price of any part in product type SG.

 
--19.	Display the id, the description, the quantity, the invoice number, and the number of units ordered for each product.  Make sure to include all products in your output.  The order number and the number of ordered units must remain blank for any product that is not contained in an invoice.  Order your display by product number.
SELECT product.prod_id, prod_desc, prod_quantity, line.invoice_num, line_num_ordered
FROM product LEFT OUTER JOIN line ON product.prod_id = line.prod_id
ORDER BY product.prod_id;
