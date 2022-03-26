select * 
from Covid_data_deaths
where continent is not null
order by 3,4

--select * 
--from covid_data_vaccinations
--order by 3,4

--select data that we are going to be using
select location, date, total_cases, new_cases, total_deaths, population
from covid_data_deaths
order by 1,2

--looking at Total Cases vs Total Deaths
--shows likelihood of dying if you contract covid in your country
select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from covid_data_deaths
where location like '%states%'
order by 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population got covid
select location, date, total_cases, population,total_cases, (total_cases/population)*100 as PercentagepopulationInfected
from covid_data_deaths
--where location like '%states%'
order by 1,2

--Looking at Countries with Highest infection rate compared to Population
select location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as  PercentagePopulationInfected
from covid_data_deaths
--where location like '%states%'
Group By location, population
order by PercentagePopulationInfected desc

--Break things down by continent

--shwowing countires with the highest death count 
select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from Covid_data_deaths
where continent is not null
group by continent
order by TotalDeathCount desc

--Global Numbers
select date, SUM(new_cases) as totalcases, SUM(cast(new_deaths as int)) as totaldeaths, SUM(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from Covid_data_deaths
--where location like '%states%'
where continent is not null
group by date
order by 1,2

--looking at Total Population vs Vaccinations 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER(partition by dea.location,
dea.date) as RollingPeopleVaccinated,

from Covid_data_deaths dea --dea is an Alias
join covid_data_vaccinations vac --vea is an Alias
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--Creating view to store data for later visualization 
Create View PerentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER(partition by dea.location,
dea.date) as RollingPeopleVaccinated
from Covid_data_deaths dea --dea is an Alias
join covid_data_vaccinations vac --vea is an Alias
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
from PerentPopulationVaccinated