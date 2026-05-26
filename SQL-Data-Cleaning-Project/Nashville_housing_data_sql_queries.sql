/* Cleaning data in SQL Queries */

select * from PortfolioProject.dbo.[Nashville Housing Data]

-------------------------------------------------------------------------

--Standardize Date Format----

select SaleDate from PortfolioProject.dbo.[Nashville Housing Data]

--Populate Property Address data--

Select * from PortfolioProject.dbo.[Nashville Housing Data] --where PropertyAddress is null 
order by ParcelId


Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress) from PortfolioProject.dbo.[Nashville Housing Data] a join PortfolioProject.dbo.[Nashville Housing Data] b on a.ParcelID=b.ParcelID
and a.[UniqueID]<>b.[UniqueID]
where a.PropertyAddress is null

Update a
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress) from PortfolioProject.dbo.[Nashville Housing Data] a join PortfolioProject.dbo.[Nashville Housing Data] b on a.ParcelID=b.ParcelID
and a.[UniqueID]<>b.[UniqueID]
where a.PropertyAddress is null

--breaking out address into Individual Columns--
Select 
substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address 
from PortfolioProject.dbo.[Nashville Housing Data] 

ALTER TABLE [Nashville Housing Data]
ADD PropertySplitAddress Nvarchar(255);

UPDATE [Nashville Housing Data]
SET PropertySplitAddress=substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)



ALTER TABLE [Nashville Housing Data]
ADD PropertySplitCity Nvarchar(255);

UPDATE [Nashville Housing Data]
SET PropertySplitCity=substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

select * from PortfolioProject.dbo.[Nashville Housing Data]

select OwnerAddress from PortfolioProject.dbo.[Nashville Housing Data]

select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1) from PortfolioProject.dbo.[Nashville Housing Data]

ALTER TABLE [Nashville Housing Data]
ADD OwnerSplitAddress Nvarchar(255)

UPDATE [Nashville Housing Data]
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE [Nashville Housing Data]
ADD OwnerSplitCity Nvarchar(255)

UPDATE [Nashville Housing Data]
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE [Nashville Housing Data]
ADD OwnerSplitState Nvarchar(255);

UPDATE [Nashville Housing Data]
SET OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'),1) 

select * from PortfolioProject.dbo.[Nashville Housing Data]

--change Y,N from yes and no in "Sold as Vacant" field--
select distinct(SoldAsVacant),count(SoldAsVacant) from PortfolioProject.dbo.[Nashville Housing Data] group by SoldAsVacant order by 2

select SoldAsVacant,
CASE When cast(SoldAsVacant AS VARCHAR)=1 THEN 'Yes'
     When cast(SoldAsVacant AS VARCHAR)=0 THEN 'No'
     ELSE cast(SoldAsVacant AS VARCHAR)
     END
from PortfolioProject.dbo.[Nashville Housing Data]

ALTER TABLE [Nashville Housing Data]
ADD SoldAsVacantConverted VARCHAR(10);

--Update [Nashville Housing Data]
--set SoldAsVacant=CASE When cast(SoldAsVacant AS VARCHAR)=1 THEN 'Yes'
     --When cast(SoldAsVacant AS VARCHAR)=0 THEN 'No'
     --ELSE cast(SoldAsVacant AS VARCHAR)
     --END
UPDATE PortfolioProject.dbo.[Nashville Housing Data]
SET SoldAsVacantConverted =
CASE 
    WHEN SoldAsVacant = 1 THEN 'Yes'
    WHEN SoldAsVacant = 0 THEN 'No'
END;

--Remove Duplicates---
with rowNumberCTE as(select *,ROW_NUMBER() over(partition by ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference order by UniqueID)row_num
from PortfolioProject.dbo.[Nashville Housing Data])

select * from rowNumberCTE where row_num>1

select * from PortfolioProject.dbo.[Nashville Housing Data]

Alter table PortfolioProject.dbo.[Nashville Housing Data]
drop column SoldAsVacant

