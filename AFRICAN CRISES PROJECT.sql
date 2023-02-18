SELECT *
FROM [AFRICA CRISES]..african_crises

--Insight 1 (Total currency crises by country)
SELECT country,sum(currency_crises) as TotalCurrencyCrises
FROM [AFRICA CRISES]..african_crises
where currency_crises >0 
group by country 
order by sum(currency_crises) desc

--counrty that had the highest number of inflation crises

SELECT country,sum(inflation_crises) as TotalInflationCrises
FROM [AFRICA CRISES]..african_crises
where  inflation_crises >0 
group by country 
order by sum(inflation_crises) desc

-- how many years did each country experience a banking crisis from 1870 - 2014

SELECT country,count(banking_crisis)as TotalbankingCrises
FROM [AFRICA CRISES]..african_crises
where  banking_crisis = 'crisis'
group by country 
order by TotalbankingCrises desc


SELECT ac.country,ac.year,ac.currency_crises,ac.inflation_crises, ac.banking_crisis,AF.systemic_crisis,AF.exch_usd,AF.domestic_debt_in_default,AF.sovereign_external_debt_default,AF.gdp_weighted_default,AF.inflation_annual_cpi,
MAX(AF.inflation_annual_cpi) over (partition by ac.country) as MaximumInflationCPI,
MIN(AF.inflation_annual_cpi) OVER (partition by ac.country) as MinimumDeflationCpi
FROM [AFRICA CRISES]..african_crises ac
join [AFRICA CRISES]..[africa_crises_ inflation] AF
     ON ac.country = AF.country
	 and ac.year =AF.year



--USING CTE

With InflationandCrises (country,year,inflation_annual_cpi, MaximumInflationCPI, MinimumDeflationCpi)
as
(
SELECT ac.country,ac.year,AF.inflation_annual_cpi,
MAX(AF.inflation_annual_cpi) over (partition by ac.country) as MaximumInflationCPI,
MIN(AF.inflation_annual_cpi) OVER (partition by ac.country) as MinimumDeflationCpi
FROM [AFRICA CRISES]..african_crises ac
join [AFRICA CRISES]..[africa_crises_ inflation] AF
    ON ac.country = AF.country
	and ac.year =  AF.year
)
select * ,( MaximumInflationCPI -MinimumDeflationCpi) as InflationCPIDifference
from InflationandCrises

--Creating a view to store data for visualisation

Create view InflationDifference as
SELECT ac.country,ac.year,ac.currency_crises,ac.inflation_crises, ac.banking_crisis,AF.systemic_crisis,AF.exch_usd,AF.domestic_debt_in_default,AF.sovereign_external_debt_default,AF.gdp_weighted_default,AF.inflation_annual_cpi,
MAX(AF.inflation_annual_cpi) over (partition by ac.country) as MaximumInflationCPI,
MIN(AF.inflation_annual_cpi) OVER (partition by ac.country) as MinimumDeflationCpi
FROM [AFRICA CRISES]..african_crises ac
join [AFRICA CRISES]..[africa_crises_ inflation] AF
     ON ac.country = AF.country
	 and ac.year =AF.year


select*
from InflationDifference

--The highest exchange rate each country had
SELECT country,MAX(exch_usd) as MaximumExchangerate
FROM [AFRICA CRISES]..InflationDifference
--where  inflation_crises >0 
group by country 
order by  MaximumExchangerate desc