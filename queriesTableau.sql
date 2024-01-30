/*

 Queries used for Tableau


 */

 -- 1.

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as double precision))/SUM(New_Cases)*100 as DeathPercentage
From deaths
Where continent is not null
Order by 1,2


-- 2.

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From deaths
Where continent is null
and location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income', 'Lower middle income', 'Low income')
Group by location
order by TotalDeathCount desc;

-- 3.

Select Location, Population, COALESCE(MAX(total_cases), 0) AS HighestInfectionCount,
    CASE
        WHEN COALESCE(MAX(total_cases), 0) = 0 THEN 0
        ELSE MAX(CAST(total_cases AS double precision) / NULLIF(Population, 0)) * 100
    END AS PercentPopulationInfected
From deaths
WHERE Population IS NOT NULL
Group by Location, Population
order by PercentPopulationInfected desc;

-- 4.

Select Location, Population, date, COALESCE(MAX(total_cases), 0) AS HighestInfectionCount,
    CASE
        WHEN COALESCE(MAX(total_cases), 0) = 0 THEN 0
        ELSE MAX(CAST(total_cases AS double precision) / NULLIF(Population, 0)) * 100
    END AS PercentPopulationInfected
From deaths
WHERE Population IS NOT NULL
Group by Location, Population, date
order by PercentPopulationInfected desc;