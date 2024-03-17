-- Business Goals

-- 1. Find the sellers' names who have posted more listings than average count of posts of all sellers who have posted at least 1 listing. 
SELECT FIRST_NAME, COUNT(LISTING_ID) AS COUNT
FROM SPRING23_S003_7_LISTING l, SPRING23_S003_7_ACCOUNT a
WHERE l.SELLER_USERNAME = a.USERNAME
GROUP BY SELLER_USERNAME, FIRST_NAME
HAVING COUNT(LISTING_ID) > 
(SELECT AVG(COUNT)
FROM
(SELECT SELLER_USERNAME, COUNT(LISTING_ID) AS COUNT
FROM SPRING23_S003_7_LISTING
GROUP BY SELLER_USERNAME))
ORDER BY COUNT DESC;

-- Sample Output
-- FIRST_NAME			          COUNT
-- ------------------------------ ----------
-- John				              29
-- Miss				              27
-- Anne				              26
-- Alexander			          25
-- Gary				              24
-- Todd				              19
-- Ruth				              11
-- David				          10

-- 8 rows selected.



-- 2. Find the most sold product category for each month. 

WITH m_c_c AS 
(SELECT MONTH, CATEGORY_NAME, COUNT(*) AS COUNT
FROM 
(SELECT BUYER_USERNAME, CATEGORY_ID, BUY_DATE, TO_CHAR(BUY_DATE, 'MON') AS MONTH
FROM SPRING23_S003_7_LISTING) l, 
SPRING23_S003_7_PRODUCT_CATEGORY pc 
WHERE l.BUYER_USERNAME IS NOT NULL AND l.CATEGORY_ID = pc.CATEGORY_ID 
GROUP BY EXTRACT(month FROM BUY_DATE), MONTH, CATEGORY_NAME
ORDER BY EXTRACT(month FROM BUY_DATE))
SELECT MONTH, CATEGORY_NAME 
FROM m_c_c a
WHERE COUNT = (SELECT MAX(COUNT) FROM m_c_c b WHERE a.MONTH = b.MONTH);

-- Sample Output
-- MONTH	    CATEGORY_NAME
-- ------------ ------------------------------
-- JAN	        Furniture
-- FEB	        Furniture
-- MAR	        Furniture
-- APR	        Electronics
-- MAY	        Kitchen
-- JUN	        Kitchen
-- JUL	        Furniture
-- AUG	        Lighting
-- SEP	        Furniture
-- OCT	        Furniture
-- NOV	        Furniture

-- MONTH	    CATEGORY_NAME
-- ------------ ------------------------------
-- DEC	        Kitchen

-- 12 rows selected.


-- 3. Identifying the most bought combination of products on the same day by the same buyer to provide suggestions in future.
SELECT CATEGORIES, COUNT(*) AS COUNT 
FROM 
(SELECT LISTAGG(DISTINCT(CATEGORY_NAME), ', ') AS CATEGORIES
FROM SPRING23_S003_7_LISTING l, SPRING23_S003_7_PRODUCT_CATEGORY pc 
WHERE BUYER_USERNAME IS NOT NULL AND BUY_DATE IS NOT NULL AND l.CATEGORY_ID = pc.CATEGORY_ID
GROUP BY BUYER_USERNAME, BUY_DATE 
HAVING COUNT(DISTINCT(CATEGORY_NAME)) > 1
ORDER BY CATEGORY_NAME ASC)
GROUP BY CATEGORIES 
ORDER BY COUNT DESC;

-- Sample Output
-- CATEGORIES                      COUNT
-- ------------------------------- ----------
-- Electronics, Storage	           1
-- Bedding, Furniture, Kitchen	   1


-- 4. Top 5 sellers with the highest ratings
SELECT REVIEWEE_USERNAME, AVG(RATING) AS AVG_RATING
FROM SPRING23_S003_7_REVIEW r, SPRING23_S003_7_SELLER s 
WHERE r.REVIEWEE_USERNAME = s.USERNAME
GROUP BY REVIEWEE_USERNAME
ORDER BY AVG_RATING DESC 
FETCH FIRST 5 ROWS ONLY;

-- Sample Output
-- REVIEWEE_USERNAME	          AVG_RATING
-- ------------------------------ ----------
-- Russell7531				               5
-- Robert1250			                 4.5
-- Brian0049			                 4.4
-- Kimberly7025		              4.33333333
-- Alexander2363				           4


-- 5. List of users who have purchased every type of subscription. 
SELECT USERNAME
FROM SPRING23_S003_7_USER u
WHERE NOT EXISTS 
(SELECT TIER
FROM SPRING23_S003_7_MEMBERSHIP_TYPE
MINUS 
SELECT DISTINCT(TIER)
FROM SPRING23_S003_7_MEMBERSHIP m 
WHERE u.USERNAME = m.USERNAME);

-- Sample Output
-- USERNAME
-- ------------------------------
-- Brian7547
-- Jessica3198


-- 6. Get the seller names and the total price of all their listings in Electronics category. Also, show the total sum of all price. 
SELECT s.USERNAME, SUM(PRICE) AS PRICE
FROM SPRING23_S003_7_SELLER s, SPRING23_S003_7_LISTING l, SPRING23_S003_7_PRODUCT_CATEGORY pc 
WHERE s.USERNAME = l.SELLER_USERNAME AND l.CATEGORY_ID = pc.CATEGORY_ID AND CATEGORY_NAME LIKE '%Electronics%'
GROUP BY ROLLUP(s.USERNAME);

-- Sample Output
-- USERNAME			              PRICE
-- ------------------------------ ----------
-- Alexander2363			            1758
-- Anne5662			                    1758
-- David6372			                 639
-- Gary8422			                    1758
-- John6488			                    1758
-- Miss6084			                    1758
-- Todd3397			                    1007
-- 				                       10436


-- 7. Get the summary of all the listings for each seller and product category. 
SELECT SELLER_USERNAME, CATEGORY_NAME, SUM(PRICE)
FROM SPRING23_S003_7_LISTING l, SPRING23_S003_7_PRODUCT_CATEGORY pc 
WHERE l.CATEGORY_ID = pc.CATEGORY_ID 
GROUP BY CUBE(SELLER_USERNAME, CATEGORY_NAME);

-- Sample Output
-- SELLER_USERNAME 	              CATEGORY_NAME		             SUM(PRICE)
-- ------------------------------ ------------------------------ ----------
-- 								                                     102415
-- 			                      Bedding				              22782
-- 			                      Kitchen				              13020
-- 			                      Storage				              10529
-- 			                      Lighting 			                   8748
-- 			                      Furniture			                  36900
-- 			                      Electronics			              10436
-- Amy7389 							                                    862
-- Amy7389 		                  Furniture			                    862
-- Anne5662							                                  12405
-- Anne5662		                  Bedding				               3264

-- SELLER_USERNAME 	              CATEGORY_NAME		             SUM(PRICE)
-- ------------------------------ ------------------------------ ----------
-- Anne5662		                  Kitchen			    	           1503
-- Anne5662		                  Storage			    	           1850
-- Anne5662		                  Lighting 			                    995
-- Anne5662		                  Furniture			                   3035
-- Anne5662		                  Electronics		    	           1758
-- Cory5365				              			                       3228
-- Cory5365		                  Bedding			                    451
-- Cory5365		                  Kitchen			    	            339
-- Cory5365		                  Lighting 			                    687
-- Cory5365		                  Furniture			                   1751
-- Gary8422							                                  11125

-- SELLER_USERNAME 	              CATEGORY_NAME		             SUM(PRICE)
-- ------------------------------ ------------------------------ ----------
-- Gary8422		                  Bedding		                       2480
-- Gary8422		                  Kitchen		                       1503
-- Gary8422		                  Storage		                       1354
-- Gary8422		                  Lighting 	                            995
-- Gary8422		                  Furniture	                           3035
-- Gary8422		                  Electronics	                       1758
-- John6488				              			                      14091
-- John6488		                  Bedding		                       4787
-- John6488		                  Kitchen		                       1503
-- John6488		                  Storage		                       1850
-- John6488		                  Lighting 	                           1158

-- SELLER_USERNAME 	              CATEGORY_NAME		             SUM(PRICE)
-- ------------------------------ ------------------------------ ----------
-- John6488		                  Furniture		           	           3035
-- John6488		                  Electronics	           		       1758
-- Miss6084				              			                      13299
-- Miss6084		                  Bedding		           		       4158
-- Miss6084		                  Kitchen		           		       1503
-- Miss6084		                  Storage		           		       1850
-- Miss6084		                  Lighting 		           	            995
-- Miss6084		                  Furniture		           	           3035
-- Miss6084		                  Electronics	           		       1758
-- Ruth1301				              			                       5033
-- Ruth1301		                  Bedding		           	    	   1073

-- SELLER_USERNAME 	              CATEGORY_NAME		             SUM(PRICE)
-- ------------------------------ ------------------------------ ----------
-- Ruth1301		                  Kitchen			           	        339
-- Ruth1301		                  Storage			           	       1183
-- Ruth1301		                  Lighting 			                    687
-- Ruth1301		                  Furniture			                   1751
-- Todd3397				              			                       8677
-- Todd3397		                  Bedding			           	       2480
-- Todd3397		                  Kitchen			           	       1503
-- Todd3397		                  Storage			           	        544
-- Todd3397		                  Lighting 			                    862
-- Todd3397		                  Furniture			                   2281
-- Todd3397		                  Electronics		           	       1007

-- SELLER_USERNAME 	              CATEGORY_NAME		             SUM(PRICE)
-- ------------------------------ ------------------------------ ----------
-- Brian0049							                               2090
-- Brian0049		              Kitchen				                339
-- Brian0049		              Furniture			                   1751
-- Brian0332				          			                        862
-- Brian0332		              Furniture			                    862
-- Brian6416				          			                       2777
-- Brian6416		              Kitchen				                339
-- Brian6416		              Lighting 			                    687
-- Brian6416		              Furniture			                   1751
-- Brian7547				          			                        862
-- Brian7547		              Kitchen				                374

-- SELLER_USERNAME 	              CATEGORY_NAME		             SUM(PRICE)
-- ------------------------------ ------------------------------ ----------
-- Brian7547		              Furniture			                    488
-- David6372				          			                       4411
-- David6372		              Bedding				                825
-- David6372		              Kitchen				                339
-- David6372		              Storage				                544
-- David6372		              Lighting 			                    687
-- David6372		              Furniture			                   1377
-- David6372		              Electronics			                639
-- James9479				          			                        862
-- James9479		              Furniture			                    862
-- Renee5028							                               1307

-- SELLER_USERNAME 	              CATEGORY_NAME		             SUM(PRICE)
-- ------------------------------ ------------------------------ ----------
-- Renee5028		              Kitchen				                339
-- Renee5028		              Furniture			                    968
-- Scott5735				          			                        862
-- Scott5735		              Furniture			                    862
-- Morgan2123				          			                       1307
-- Morgan2123		              Kitchen				                339
-- Morgan2123		              Furniture			                    968
-- Robert1250				          			                       1307
-- Robert1250		              Kitchen				                339
-- Robert1250		              Furniture			                    968
-- Jessica3198							                               1201

-- SELLER_USERNAME 	              CATEGORY_NAME		             SUM(PRICE)
-- ------------------------------ ------------------------------ ----------
-- Jessica3198		              Kitchen				                339
-- Jessica3198		              Furniture			                    862
-- Matthew8220				          			                        374
-- Matthew8220		              Furniture			                    374
-- Rebecca7229				          			                       2090
-- Rebecca7229		              Kitchen				                339
-- Rebecca7229		              Furniture			                   1751
-- Russell7531				          			                       1100
-- Russell7531		              Kitchen				                238
-- Russell7531		              Furniture			                    862
-- Kimberly7025							                                374

-- SELLER_USERNAME 	              CATEGORY_NAME		             SUM(PRICE)
-- ------------------------------ ------------------------------ ----------
-- Kimberly7025		              Furniture			                    374
-- Alexander2363			      			                          11909
-- Alexander2363		          Bedding				               3264
-- Alexander2363		          Kitchen				               1503
-- Alexander2363		          Storage				               1354
-- Alexander2363		          Lighting 			                    995
-- Alexander2363		          Furniture			                   3035
-- Alexander2363		          Electronics			               1758

-- 107 rows selected.


-- 8. OVER function. Get the ranking of the top 3 buyers who bought the highest sum in each product category. 
SELECT CATEGORY_NAME, BUYER_USERNAME, RANKING
FROM 
(SELECT CATEGORY_NAME, BUYER_USERNAME, RANK() OVER(PARTITION BY CATEGORY_NAME ORDER BY TOTAL_PRICE DESC) AS RANKING
FROM 
(SELECT BUYER_USERNAME, CATEGORY_NAME, SUM(PRICE) AS TOTAL_PRICE
FROM SPRING23_S003_7_LISTING l, SPRING23_S003_7_PRODUCT_CATEGORY pc 
WHERE l.CATEGORY_ID = pc.CATEGORY_ID AND BUYER_USERNAME IS NOT NULL
GROUP BY CATEGORY_NAME, BUYER_USERNAME))
WHERE RANKING <= 3;

-- Sample Output
-- CATEGORY_NAME		          BUYER_USERNAME			     RANKING
-- ------------------------------ ------------------------------ ----------
-- Bedding 		                  Mason3504			                      1
-- Bedding 		                  Joshua1826			                  2
-- Bedding 		                  Thomas6139			                  3
-- Electronics		              Andrew3923			                  1
-- Electronics		              Jim9833				                  2
-- Electronics		              Matthew5226			                  3
-- Furniture		              Matthew5226			                  1
-- Furniture		              Holly3028			                      2
-- Furniture		              Ariel0584			                      3
-- Kitchen 		                  Matthew5226			                  1
-- Kitchen 		                  Jeff6377 			                      2

-- CATEGORY_NAME		          BUYER_USERNAME			     RANKING
-- ------------------------------ ------------------------------ ----------
-- Kitchen 		                  David8146			                      3
-- Lighting		                  Richard4404			                  1
-- Lighting		                  Chloe4828			                      2
-- Lighting		                  Jim9833				                  3
-- Storage 		                  Katherine2657			                  1
-- Storage 		                  Aaron6289			                      2
-- Storage 		                  Corey8349			                      3

-- 18 rows selected.


-- 9. Top categories with the higher number of listings than average
SELECT CATEGORY_NAME, COUNT(LISTING_ID) AS COUNT
FROM SPRING23_S003_7_LISTING l, SPRING23_S003_7_PRODUCT_CATEGORY pc
WHERE l.CATEGORY_ID = pc.CATEGORY_ID
GROUP BY l.CATEGORY_ID, CATEGORY_NAME
HAVING COUNT(LISTING_ID) > 
(SELECT AVG(COUNT)
FROM
(SELECT CATEGORY_ID, COUNT(LISTING_ID) AS COUNT 
FROM SPRING23_S003_7_LISTING
GROUP BY CATEGORY_ID))
ORDER BY COUNT DESC;

-- Sample Output
-- CATEGORY_NAME			      COUNT
-- ------------------------------ ----------
-- Furniture			          93
-- Kitchen 			              46
