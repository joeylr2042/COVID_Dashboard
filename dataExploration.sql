/*
Covid 19 Data Exploration

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

Select *
From deaths
Where continent is not null
order by 3, 4;


-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From deaths
Where continent is not null
order by 1, 2;


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location,
       date,
       total_cases,
       total_deaths,
       cast(total_deaths as decimal(10, 2)) / total_cases * 100 as DeathPercentage
From deaths
-- Where location like '%states%'
where continent is not null
order by 1, 2;

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,   (cast(total_cases as double precision) / population)*100 as PercentPopulationInfected
From deaths
--Where location like '%states%'
order by 1,2;

-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((cast(total_cases as double precision) / population))*100 as PercentPopulationInfected
From deaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From deaths
--Where location like '%states%'
Where continent is not null
Group by Location
order by TotalDeathCount desc

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From deaths
--Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc;

-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, cast(SUM(cast(new_deaths as int)) as double precision)/SUM(New_Cases)*100 as DeathPercentage
From deaths
--Where location like '%states%'
where continent is not null
--Group By date
order by 1,2;

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as integer)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From deaths dea
Join vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3;

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as integer)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From deaths dea
Join vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (cast(RollingPeopleVaccinated as double precision)/Population)*100
From PopvsVac

