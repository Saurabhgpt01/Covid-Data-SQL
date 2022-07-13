--cleaning data in sql query

select ConvertedSaleDate,SaleDate, CONVERT(DATE,SaleDate) 
From PortfolioDatabase..nashville



ALTER TABLE nashville
ADD ConvertedSaleDate Date;

update nashville
set ConvertedSaleDate = CONVERT(Date, SaleDate)

--Populate Property Address


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
From PortfolioDatabase..nashville a
join PortfolioDatabase..nashville b
    on a.ParcelID = b.ParcelID
    and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--UPDATING NULL VALUES IN PROPERTY ADDRESS

UPDATE a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioDatabase..nashville a
join PortfolioDatabase..nashville b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- breaking out address into mul;tiple columns(Address,City , State)


select PropertyAddress from PortfolioDatabase..nashville


select 
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
,substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
FROM PortfolioDatabase..nashville


ALTER TABLE nashville
ADD PropettySplitAddress Nvarchar(255);

update nashville
set PropettySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)



ALTER TABLE nashville
ADD PropertySplitCity Nvarchar(255);

SELECT * FROM PortfolioDatabase..nashville

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM PortfolioDatabase..nashville


--updating address
ALTER TABLE nashville
ADD OwnerSplitAddress Nvarchar(255);

update nashville
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

--updating city

ALTER TABLE nashville
ADD OwnerSplitCity Nvarchar(255);

update nashville
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

-- updating state

ALTER TABLE nashville
ADD OwnerSplitState Nvarchar(255);

update nashville
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


-- change in y and n to yes and no in sold as vaccant feild

SELECT Distinct(SoldASVacant), COUNT(SoldASVacant)
FROM PortfolioDatabase..nashville
group by SoldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant = 'y' then 'yes'
	   when SoldAsVacant = 'n' then 'no'
	   else SoldAsVacant
	   end
FROM PortfolioDatabase..nashville


update nashville
set SoldAsVacant = case when SoldAsVacant = 'y' then 'yes'
	   when SoldAsVacant = 'n' then 'no'
	   else SoldAsVacant
	   end
FROM PortfolioDatabase..nashville

--remove duplicates

with RowNumCTE as(
select *, 
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 LegalReference
				 order BY 
				 UniqueID) ROW_NUM


from PortfolioDatabase..nashville

--order by ParcelID
)
select * from RowNumCTE




