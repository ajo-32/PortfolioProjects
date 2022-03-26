

select * 
from Covid_data_deaths
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

--Showing Countries with Highest Death Count per Population