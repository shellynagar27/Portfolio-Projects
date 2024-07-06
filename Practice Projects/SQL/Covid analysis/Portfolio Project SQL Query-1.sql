use PortfolioProject;

Select * 
from PortfolioProject..CovidDeaths
-- can also write from PortfolioProject.dbo.CovidDeaths
where continent is not null
order by 3,4

-- counting null values in continent column
select count(*) as total_values, (count(*)-count(continent)) as null_values
from CovidDeaths

Select * 
from PortfolioProject..CovidVaccination
where continent is not null
order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

-- looking at total_cases VS total_deaths in India
select location, date, total_cases, total_deaths, concat(round((total_deaths/total_cases)*100,2),'%') as death_percentage
from PortfolioProject..CovidDeaths
where location= 'India' and total_deaths is not null
order by 1,2

-- looking at total_cases VS population
select location, date,population, total_cases,  concat(round((total_cases/population)*100,2),'%') as affected_percentage
from PortfolioProject..CovidDeaths
where location= 'India'
order by 1,2

-- looking at countires with highest infection rate compared to population
select location,population, max(total_cases) as HighestInfectionCount,  concat(round((max(total_cases)/population)*100,2),'%') as affected_percentage, concat(round(max(total_cases/population)*100,2),'%') as trial_percentage
from PortfolioProject..CovidDeaths
group by location, population
order by affected_percentage DESC;

-- showing countries with highest death count per population
select location, population, max(cast(total_deaths as int)) as max_deaths_count, sum(cast(total_deaths as int)) as total_Deaths, round(sum(cast(total_deaths as int))/population,2) as deaths_per_population
from PortfolioProject..CovidDeaths
where continent is not null
group by location, population
order by deaths_per_population DESC;

-- showing continents with highest death count 
select continent, max(cast(total_deaths as int)) as total_deaths_count
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by total_deaths_count  DESC;

-- shows total cases
select date, sum(new_cases)
from PortfolioProject..CovidDeaths
where continent is not null
Group by date
order by 1,2

-- death percentage of new cases
select date, sum(new_cases) as new_cases, sum(cast(new_deaths as int)) as new_death, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentagefromNewCases
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2

-- joining at two columns which is common in both
select *
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
on dea.location=vac.location
and dea.date=vac.date


-- looking at population VS total vaccination 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
on dea.location=vac.location
and dea.date=vac.date
where vac.new_vaccinations is not null and dea.continent is not null 
order by 1,2

-- new vaccination and cummulative total vaccination in each country
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as cummulative_new_vaccination
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null and vac.new_vaccinations is not null
order by 2,3


-- usind CTE to show new vaccination, cummulative vaccination and vaccination percentage
with PopVSVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null 
-- order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from PopVSVac


-- Temp table
drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
on dea.location=vac.location
and dea.date=vac.date
--where dea.continent is not null 
-- order by 2,3

select *, (RollingPeopleVaccinated/population)*100
from #percentpopulationvaccinated


-- creating view to store data for later visualization
create view percentpopulationvaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccination vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null 
-- order by 2,3

select * 
from percentpopulationvaccinated 