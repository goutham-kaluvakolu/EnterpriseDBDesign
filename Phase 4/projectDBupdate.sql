-- Removes a category bought on the same day
UPDATE SPRING23_S003_7_LISTING
SET CATEGORY_ID = '0'
WHERE LISTING_ID = '5711051';

-- Removes a user from buying all 3 tiers
UPDATE SPRING23_S003_7_MEMBERSHIP
SET TIER = 'Gold'
WHERE MEMBERSHIP_ID = '7783021';

-- Changes 3 listings category from Electronics to Kitchen
UPDATE SPRING23_S003_7_LISTING
SET CATEGORY_ID = '1'
WHERE LISTING_ID IN ('3558590', '6938263', '1903839');

-- Changes all 5 star ratings to 1 star
UPDATE SPRING23_S003_7_REVIEW
SET RATING = '1'
WHERE RATING = '5';

-- Changes all of a specific buyer's listing's price to be very low
UPDATE SPRING23_S003_7_LISTING
SET PRICE = 1
WHERE BUYER_USERNAME = 'Mason3504';

-- Change all of December's listings to category Lighting
UPDATE SPRING23_S003_7_LISTING
SET CATEGORY_ID = '3'
WHERE TO_CHAR(BUY_DATE, 'MON') = 'DEC';

-- Delete all photos based on conditions
DELETE FROM SPRING23_S003_7_LISTING_PHOTOS
WHERE LISTING_ID IN ('2145129', '2145129', '289111');

-- Delete all reviews that have the word 'major'
DELETE FROM SPRING23_S003_7_REVIEW
WHERE REVIEW LIKE '%major%';

-- Insert some listings where Miss is the seller 
Insert into SPRING23_S003_7_LISTING Values ('5037189','Furniture','Incredible office chair.','237','0','Miss6084','Cassandra6746',DATE'2020-09-16',DATE'2019-01-26');
Insert into SPRING23_S003_7_LISTING Values ('5037182','Furniture','The best of all sofas.','237','0','Miss6084','Cassandra6746',DATE'2020-09-16',DATE'2019-05-26');
Insert into SPRING23_S003_7_LISTING Values ('5037183','Furniture','Featherless cushion','237','0','Miss6084','Cassandra6746',DATE'2020-09-16',DATE'2019-08-26');
