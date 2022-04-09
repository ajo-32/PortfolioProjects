/*
Cleaning Data in SQL Queries

*/

select *
from NashvilleHousing


--Standardize Date Format
select SaleDateConverted, CONVERT(Date,SaleDate)
from NashvilleHousing

Update NashvilleHousing
Set SaleDate = CONVERT(Date,SaleDate)


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = CONVERT(Date,SaleDate)




--Populate Property Address data
select *
from NashvilleHousing
--where PropertyAddress is null 
order by ParcelID 

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[uniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

Update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[uniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null


--Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
FROM NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress NVARCHAR(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity NVARCHAR(255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

select * 
from NashvilleHousing

select OwnerAddress 
from NashvilleHousing


select 
PARSENAME(REPLACE(OwnerAddress,',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress,',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress,',', '.'),1)
from NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity NVARCHAR(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState NVARCHAR(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.'),1)

select *
from NashvilleHousing



--Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), count(SoldAsVacant)
from NashvilleHousing
Group By SoldAsVacant
Order by 2


Select SoldAsVacant
, Case when SoldAsVacant = 'Y' THEN 'Yes'
		when SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
	when SoldasVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END


--Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID, 
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
				UniqueID
				) row_num

FROM NashvilleHousing
--order by ParcelID
	)

SELECT * 
FROM RowNumCTE
where row_num > 1
order by PropertyAddress



--Delete Unused Columns

Select * 
from NashvilleHousing

ALTER TABLE NashvilleHousing 
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE NashvilleHousing 
DROP COLUMN SaleDate
