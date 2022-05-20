CREATE DATABASE portfolio_project;
USE portfolio_project;

SELECT * FROM coviddeaths
Order by 3,4;


SELECT * FROM covidvaccinations;

SELECT location, date, total_cases,new_cases, total_deaths, population
FROM coviddeaths
ORDER BY 1, 2;

-- Looking at Total Cases vs Total Deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM coviddeaths;

UPDATE coviddeaths
SET total_deaths = NULL
WHERE (total_deaths = '');

UPDATE coviddeaths
SET continent = NULL
WHERE (continent = '');

-- Likelihood of dying if you get covid in Ghana

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM coviddeaths
WHERE location LIKE '%ghana%';

-- Percentage of population that got covid

Select location, date, total_cases, population, (total_cases/population)*100 AS death_percentage
FROM coviddeaths;
-- WHERE location LIKE '%ghana%'

-- Countries with highest infection rate

Select location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM coviddeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;


-- Countries with highest death count per population
Select location, MAX(cast(total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Continents with highest death count per population
Select location, MAX(cast(total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM coviddeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- GLOBAL Numbers
SELECT  SUM(new_cases) AS TotalCases, SUM(new_deaths) AS TotalDeaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
FROM portfolio_project.coviddeaths
WHERE continent IS NOT NULL 
-- GROUP BY date
ORDER BY 1, 2;


-- Looking at Total Population vs Vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM portfolio_project.coviddeaths AS dea
JOIN portfolio_project.covidvaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3;






















