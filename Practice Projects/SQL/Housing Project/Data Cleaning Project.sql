/*
cleaning data in SQL Queries
*/

use [Data Cleaning project];

select *
from [Data Cleaning project].dbo.Nashville_housing
-------------------------------------------------------------------------------------------------

-- standardize Date format
-- didnot work
select SaleDate, convert(date,SaleDate)
from [Data Cleaning project].dbo.Nashville_housing

-- method-1
update Nashville_housing
set SaleDate=convert(date,SaleDate) -- didnt work

-- method-2
-- first added the column
alter table Nashville_housing
add SaleDateConverted Date;

-- inserted value in the column
update Nashville_housing
set SaleDateConverted=convert(date,SaleDate)

-------------------------------------------------------------------------------------------------------
-- Populate Property Address Data
select *
from [Data Cleaning project].dbo.Nashville_housing
--where PropertyAddress is null
order by ParcelID

-- by observation where parcel ID is same PropertyID is also same
-- hence if at one place if we have address we can put it in the other place also
select  a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Data Cleaning project].dbo.Nashville_housing as a
join [Data Cleaning project].dbo.Nashville_housing as b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Data Cleaning project].dbo.Nashville_housing as a
join [Data Cleaning project].dbo.Nashville_housing as b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

----------------------------------------------------------------------------------------------
-- Breaking out Address into individual columns (Address, City, State)
select PropertyAddress
from [Data Cleaning project].dbo.Nashville_housing

select 
substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)-CHARINDEX(',',PropertyAddress)) as state,
substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as state2
from [Data Cleaning project].dbo.Nashville_housing


--creating two new columns 1 for address and 1 for state
alter table [Data Cleaning project].dbo.Nashville_housing
add PropertySplitAddress nvarchar(255)

update [Data Cleaning project].dbo.Nashville_housing
set PropertySplitAddress=substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table [Data Cleaning project].dbo.Nashville_housing
add PropertySplitCity nvarchar(255)

update [Data Cleaning project].dbo.Nashville_housing
set PropertySplitCity=substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

select *
from [Data Cleaning project].dbo.Nashville_housing

------------------------------------------------------------------------------------------
-- Owner's address
select OwnerAddress
from [Data Cleaning project].dbo.Nashville_housing

select PARSENAME(OwnerAddress,1)--  nothing happend cause PARSENAME looks for period
from [Data Cleaning project].dbo.Nashville_housing

-- this separates everything but backwards
select PARSENAME(replace(OwnerAddress,',','.'),1),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),3)
from [Data Cleaning project].dbo.Nashville_housing

-- for separating forwardly
select PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from [Data Cleaning project].dbo.Nashville_housing

alter table [Data Cleaning project].dbo.Nashville_housing
add OwnerSplitAddress nvarchar(255)

update [Data Cleaning project].dbo.Nashville_housing
set OwnerSplitAddress=PARSENAME(replace(OwnerAddress,',','.'),3)

alter table [Data Cleaning project].dbo.Nashville_housing
add OwnerSplitCity nvarchar(255)

update [Data Cleaning project].dbo.Nashville_housing
set OwnerSplitCity=PARSENAME(replace(OwnerAddress,',','.'),2)

alter table [Data Cleaning project].dbo.Nashville_housing
add OwnerSplitState nvarchar(255)

update [Data Cleaning project].dbo.Nashville_housing
set OwnerSplitState=PARSENAME(replace(OwnerAddress,',','.'),1)

select *
from [Data Cleaning project].dbo.Nashville_housing

--------------------------------------------------------------------------------------------------------
-- changing Y & N to Yes & No in SoldAsVacant column or field

select distinct(SoldAsVacant), count(*)
from [Data Cleaning project].dbo.Nashville_housing
group by SoldAsVacant
order by SoldAsVacant

select replace(SoldAsVacant,'No','N')
from [Data Cleaning project]..Nashville_housing

-- or
select SoldAsVacant,
case
	when SoldAsVacant='N' then 'No'
	when SoldAsVacant='Y' then 'Yes'
	Else SoldAsVacant
end
from [Data Cleaning project]..Nashville_housing

update [Data Cleaning project]..Nashville_housing
set SoldAsVacant =case
						when SoldAsVacant='N' then 'No'
						when SoldAsVacant='Y' then 'Yes'
						Else SoldAsVacant
					end


-----------------------------------------------------------------------------------------------
-- Remove Duplicates
-- generally we dont delete data in SQL Server-not a common practice
-- just for demonstration

select *
from [Data Cleaning project]..Nashville_housing

with RowNumCTE as 
(
select *, ROW_NUMBER() over(
							partition by ParcelID,
										 PropertyAddress,
										 SalePrice,
										 SaleDate,
										 LegalReference
										 order by
												UniqueID) row_num
from [Data Cleaning project]..Nashville_housing
--order by ParcelID
) select * 
from RowNumCTE
where row_num>1
order by PropertyAddress

with RowNumCTE as 
(
select *, ROW_NUMBER() over(
							partition by ParcelID,
										 PropertyAddress,
										 SalePrice,
										 SaleDate,
										 LegalReference
										 order by
												UniqueID) row_num
from [Data Cleaning project]..Nashville_housing
--order by ParcelID
) 
Delete
from RowNumCTE
where row_num>1

-----------------------------------------------------------------------------------------------------------
-- Delete Unused Columns

select *
from [Data Cleaning project]..Nashville_housing

Alter table [Data Cleaning project]..Nashville_housing
drop column OwnerAddress, PropertyAddress, TaxDistrict

Alter table [Data Cleaning project]..Nashville_housing
drop column SaleDate

	