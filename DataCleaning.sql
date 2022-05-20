SELECT * 
FROM portfolio_project.nashville_housing;


-- Populate Property Address 

UPDATE portfolio_project.nashville_housing
SET PropertyAddress = NULL
WHERE (PropertyAddress = '');

SELECT *
FROM portfolio_project.nashville_housing
-- WHERE PropertyAddress IS NULL
ORDER BY ParcelID;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, IFNULL(a.PropertyAddress, b.PropertyAddress)
FROM portfolio_project.nashville_housing AS a
JOIN portfolio_project.nashville_housing AS b
	ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;

UPDATE portfolio_project.nashville_housing AS a 
JOIN portfolio_project.nashville_housing AS b
	ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = b.PropertyAddress
WHERE a.PropertyAddress IS NULL;


-- Breaking out Address into Individual columns

SELECT PropertyAddress
FROM portfolio_project.nashville_housing
-- WHERE PropertyAddress IS NULL
ORDER BY ParcelID;

SELECT
SUBSTRING(PropertyAddress, 1, locate(',', PropertyAddress, 1) -1) AS Address,
SUBSTRING(PropertyAddress, locate(',', PropertyAddress, 1) +1, LENGTH(PropertyAddress)) AS Address
FROM portfolio_project.nashville_housing;

ALTER TABLE nashville_housing
ADD PropertySplitAddress varchar(255);

UPDATE nashville_housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, locate(',', PropertyAddress, 1) -1);

ALTER TABLE nashville_housing
ADD PropertySplitCity varchar(255);

UPDATE nashville_housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, locate(',', PropertyAddress, 1) +1, LENGTH(PropertyAddress));


-- SPLITING OWNER ADDRESS
UPDATE portfolio_project.nashville_housing
SET OwnerAddress = NULL
WHERE (OwnerAddress = '');

SELECT OwnerAddress
FROM portfolio_project.nashville_housing;

SELECT
SUBSTRING_INDEX(OwnerAddress, ',', 1) AS OwnerSplitAddress,
SUBSTRING_INDEX (SUBSTRING_INDEX(OwnerAddress, ',', '2'), ',', -1) AS OwnerSplitCity,
SUBSTRING_INDEX(OwnerAddress, ',', -1) AS OwnerSplitState
FROM portfolio_project.nashville_housing;

ALTER TABLE nashville_housing
ADD OwnerSplitAddress varchar(255);

UPDATE nashville_housing
SET OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress, ',', 1);

ALTER TABLE nashville_housing
ADD OwnerSplitCity varchar(255);

UPDATE nashville_housing
SET OwnerSplitCity = SUBSTRING_INDEX (SUBSTRING_INDEX(OwnerAddress, ',', '2'), ',', -1);

ALTER TABLE nashville_housing
ADD OwnerSplitState varchar(255);

UPDATE nashville_housing
SET OwnerSplitState = SUBSTRING_INDEX(OwnerAddress, ',', -1);


-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM portfolio_project.nashville_housing
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
         ELSE SoldAsVacant
         END
FROM portfolio_project.nashville_housing;

UPDATE nashville_housing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
         ELSE SoldAsVacant
         END;

-- Showing Duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
    PARTITION BY ParcelID,
				 PropertyAddress,
                 SalePrice,
                 SaleDate,
                 LegalReference
                 ORDER BY 
					UniqueID
                    ) row_num
FROM portfolio_project.nashville_housing
-- ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE 
WHERE row_num > 1
;

SELECT *
FROM portfolio_project.nashville_housing;

ALTER TABLE portfolio_project.nashville_housing
DROP COLUMN PropertyAddress,
DROP COLUMN OwnerAddress,
DROP COLUMN TaxDistrict;




























