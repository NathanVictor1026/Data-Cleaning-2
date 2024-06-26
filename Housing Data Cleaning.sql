SELECT *
FROM housing_data;

-- REMOVING DUPLICATES.
SELECT *, ROW_NUMBER() OVER(PARTITION BY ParcelID, PropertyAddress, 
				SaleDate, SalePrice, YearBuilt ORDER BY UniqueID) as dup_num
FROM housing_data;

WITH duplicates_cte AS
(SELECT *, ROW_NUMBER() OVER(PARTITION BY ParcelID, PropertyAddress, 
				SaleDate, SalePrice, YearBuilt ORDER BY UniqueID) as dup_num
FROM housing_data
)
SELECT * FROM duplicates_cte
WHERE dup_num > 1;

-- Test out 2-3 rows to check for authenticity.
SELECT *
FROM housing_data
WHERE PropertyAddress = '512 MONICA  AVE, GOODLETTSVILLE'; -- Everything's all good.

-- Create another table with contents of the CTE.
CREATE TABLE `housing_data2` (
  `UniqueID` int DEFAULT NULL,
  `ParcelID` text,
  `LandUse` text,
  `PropertyAddress` text,
  `SaleDate` text,
  `SalePrice` int DEFAULT NULL,
  `LegalReference` text,
  `SoldAsVacant` text,
  `OwnerName` text,
  `OwnerAddress` text,
  `Acreage` double DEFAULT NULL,
  `TaxDistrict` text,
  `LandValue` int DEFAULT NULL,
  `BuildingValue` int DEFAULT NULL,
  `TotalValue` int DEFAULT NULL,
  `YearBuilt` int DEFAULT NULL,
  `Bedrooms` int DEFAULT NULL,
  `FullBath` int DEFAULT NULL,
  `HalfBath` int DEFAULT NULL,
  `drop_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insert Contents into the new table.
INSERT INTO housing_data2
SELECT *, ROW_NUMBER() OVER(PARTITION BY ParcelID, PropertyAddress, 
				SaleDate, SalePrice, YearBuilt ORDER BY UniqueID) as dup_num
FROM housing_data;

-- Delete according to the condition that satisfies the duplicates.
DELETE FROM housing_data2
where drop_num > 1;

SELECT * FROM housing_data2;

-- STANDARDISING THE DATA. START WITH DATE.
SELECT SaleDate FROM housing_data2;
-- Its noted that the coulmn sale date is text and should be date. so we have to convert it.
SELECT SaleDate, str_to_date(SaleDate, '%M%d,%Y') FROM housing_data2;
-- Note: We use capital letters on M,D or Y to indicate the full month, day, or year
-- Update the table.
UPDATE housing_data2
SET SaleDate = str_to_date(SaleDate, '%M%d,%Y'); -- We check all columns that need to be standardised.

SELECT SoldAsVacant, COUNT(SoldAsVacant)
FROM housing_data2
GROUP BY SoldAsVacant
ORDER BY 2 ASC; -- Notice some N's and Y's instead of No or Yes.

-- To change the above problem, we can use two update statements or a case statement.
UPDATE housing_data2
SET SoldAsVacant = 'Yes'
WHERE SoldAsVacant = 'Y';

UPDATE housing_data2
SET SoldAsVacant = 'No'
WHERE SoldAsVacant = 'N';


-- Splitting the address into individual addresses and cities.
-- Create a new column 
ALTER TABLE housing_data2
ADD COLUMN SplitPropertyAddress TEXT AFTER PropertyAddress;

ALTER TABLE housing_data2
ADD COLUMN SplitPropertyCity TEXT AFTER PropertyAddress;

-- Update Those new columns.
select * from housing_data2;
UPDATE housing_data2
SET SplitPropertyCity = TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1)) ;

UPDATE housing_data2
SET SplitPropertyAddress = SUBSTRING_INDEX(PropertyAddress, ',', 1) ;


-- Its time to split OwnerAddress into its constituents. It will get complicated.   
ALTER TABLE housing_data2
ADD COLUMN SplitOwnerState TEXT AFTER OwnerName;
UPDATE housing_data2
SET SplitOwnerState = SUBSTRING_INDEX(OwnerAddress, ',', -1);


ALTER TABLE housing_data2
ADD COLUMN SplitOwnerCity TEXT AFTER OwnerName;
UPDATE housing_data2
SET SplitOwnerCity = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', -2), ',', 1));

ALTER TABLE housing_data2
ADD COLUMN SplitOwnerAddress TEXT AFTER OwnerName;
UPDATE housing_data2
SET SplitOwnerAddress = SUBSTRING_INDEX(OwnerAddress, ',', 1); -- There! Done!


-- NOW LETS DELETE UNWANTED COLUMNS AND ROWS.
ALTER TABLE housing_data2
DROP COLUMN PropertyAddress;
ALTER TABLE housing_data2
DROP COLUMN OwnerAddress;
ALTER TABLE housing_data2
DROP COLUMN drop_num;
ALTER TABLE housing_data2
DROP COLUMN TaxDistrict;


-- AND THE DATA SET IS FINALLY CLEAN AND READY FOR EXPLORING!


select t1.OwnerName, t2.OwnerName
from housing_data2 t1
join housing_data2 t2 on t1.SplitOwnerAddress = t2.SplitOwnerAddress
where t1.OwnerName = '' and t2.OwnerName != ''; 