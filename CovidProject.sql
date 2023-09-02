SELECT *
FROM Project.coviddeaths
WHERE continent is not null;

-- SELECT * 
-- FROM Project.covidvaccinations;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Project.coviddeaths
WHERE continent is not null;

-- LOOKING AT THE TOTAL CASES VS TOTAL DEATHS
-- SHOWS LIKELIHOOD OF DYING IF YOU CONTRACT COVID IN US
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM Project.coviddeaths
WHERE location like '%states%'
AND continent is not null;

-- TOTAL CASES VS POPULATION 
-- SHOWS WHAT PERCEBTAGE OF POPULATION GOT COVID


SELECT location, date, population,total_cases, (total_cases/population)*100 as PercentPopulationInfected
FROM Project.coviddeaths
WHERE location like '%states%';

-- LOOKING AT COUNTRIES WITH HIGEST INFECTION RATE COMPARED TO POPULATION

SELECT location, population, MAX(total_cases) as HigethstInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM Project.coviddeaths
-- WHERE location like '%states%';
GROUP BY location, population
ORDER BY PercentPopulationInfected desc;


-- SHOWING THE COUNTRIES WITH THE HIGHEST DEATH COUNT PER POPULATION -- 


 -- LETS BREAK THINGS DOWN BY CONTINENT 
 
SELECT continent, MAX(cast((total_deaths) as UNSIGNED)) as TotalDeathCount
FROM Project.coviddeaths
-- WHERE location like '%states%';
WHERE continent is NOT NULL 
GROUP BY continent
ORDER BY TotalDeathCount desc;

-- LOOKING AT THE COUNTRIES WITH THE HIGHEST DEATH COUNT PER POPULATION

SELECT location, population, MAX(cast((total_deaths) as UNSIGNED)) AS TotalDeathCount
FROM Project.coviddeaths
GROUP BY location, population;

-- SHOWING THE CONTINENT WITH THE HIGHEST DEATH COUNT 

SELECT continent,  MAX(cast((total_deaths) as UNSIGNED)) as TotalDeathCount
FROM Project.coviddeaths
-- WHERE location like '%states%';
WHERE continent is NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount desc;

-- GLOABL NUMBERS TOTAL DEATH PERCENTAGE BY DATE

SELECT date, SUM(CAST((new_cases) as UNSIGNED)) as total_cases, SUM(CAST((new_deaths) as UNSIGNED)) as total_deaths, SUM(cast((new_deaths) as UNSIGNED))/SUM(new_cases)*100 as DeathPercentage
FROM Project.coviddeaths
WHERE continent is not null
GROUP BY date;

-- TOTAL DEATH PERCENTAGE 

SELECT SUM(CAST((new_cases) as UNSIGNED)) as total_cases, SUM(CAST((new_deaths) as UNSIGNED)) as total_deaths, SUM(cast((new_deaths) as UNSIGNED))/SUM(new_cases)*100 as DeathPercentage
FROM Project.coviddeaths
WHERE continent is not null;

-- LOOKING AT TOTAL POPULATION VS VACCINATION


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST((vac.new_vaccinations) as UNSIGNED))  OVER (Partition BY dea.location ORDER BY dea.location, dea.date)
as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/Population)*100
FROM Project.coviddeaths dea
Join Project.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date;


-- USE CTE 

WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(CONV(vac.new_vaccinations, 16, 10) as UNSIGNED INTEGER)) OVER (Partition BY dea.location ORDER BY dea.location, dea.date)
as RollingPeopleVaccinated
 -- (RollingPeopleVaccinated/Population)*100
FROM Project.coviddeaths dea
Join Project.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date

)
SELECT * ,(RollingPeopleVaccinated/Population)*100
FROM PopvsVac; 


-- TEMP TABLE 

DROP TABLE if exists PercentPopulationVaccinated;
CREATE TABLE PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar (255), 
date datetime, 
population numeric, 
new_vaccinations numeric, 
RollingPeopleVaccinated numeric
);

INSERT INTO PercentPopulationVaccinated 

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(CONV(vac.new_vaccinations, 16, 10) as UNSIGNED INTEGER))  OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/Population)*100
FROM Project.coviddeaths dea
Join Project.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date

SELECT * ,(RollingPeopleVaccinated/Population)*100
FROM PercentPopulationVaccinated;


-- CREATING VIEW TO STORE DATA FOR LATER VIZUALIZATIONS - ROLLING PEOPLE VACCINATED 
DROP TABLE if exists PercentPopulationVaccinated;
CREATE VIEW PercentPopulationVaccinated as 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST((vac.new_vaccinations) as UNSIGNED INTEGER)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
as RollingPeopleVaccinated
 -- (RollingPeopleVaccinated/Population)*100
FROM Project.coviddeaths dea
Join Project.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date


SELECT * 
FROM PercentPopulationVaccinated;

-- CREATING VIEW TOTAL DEATH PERCENTAGE 

CREATE VIEW TotalDeathPercentage as 
SELECT SUM(CAST((new_cases) as UNSIGNED)) as total_cases, SUM(CAST((new_deaths) as UNSIGNED)) as total_deaths, SUM(cast((new_deaths) as UNSIGNED))/SUM(new_cases)*100 as DeathPercentage
FROM Project.coviddeaths
WHERE continent is not null;

-- CREATING VIEW TOTAL DEATH PERCENTAGE TOTAL DEATH PERCENTAGE BY DATE

CREATE VIEW TotalDeathPercentageByDate as 
SELECT date, SUM(CAST((new_cases) as UNSIGNED)) as total_cases, SUM(CAST((new_deaths) as UNSIGNED)) as total_deaths, SUM(cast((new_deaths) as UNSIGNED))/SUM(new_cases)*100 as DeathPercentage
FROM Project.coviddeaths
WHERE continent is not null
GROUP BY date;

-- CREATING VIEW THE CONTINENT WITH THE HIGHEST DEATH COUNT 

CREATE VIEW TotalDeathCount as 
SELECT continent,  MAX(cast((total_deaths) as UNSIGNED)) as TotalDeathCount
FROM Project.coviddeaths
-- WHERE location like '%states%';
WHERE continent is NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount desc;

-- CREATING VIEW COUNTRIES WITH THE HIGHEST DEATH COUNT PER POPULATION

CREATE VIEW TotalDeathCountbyCountry as 
SELECT location, population, MAX(cast((total_deaths) as UNSIGNED)) AS TotalDeathCount
FROM Project.coviddeaths
GROUP BY location, population;

-- CREATING VIEW SHOWING THE CONTINENT WITH THE HIGHEST DEATH COUNT PER POPULATION
CREATE VIEW TotalDeathCountbyContinent as 
SELECT continent, MAX(cast((total_deaths) as UNSIGNED)) as TotalDeathCount
FROM Project.coviddeaths
-- WHERE location like '%states%';
WHERE continent is NOT NULL 
GROUP BY continent
ORDER BY TotalDeathCount desc;


-- CREATING VIEW LOOKING AT COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION
CREATE VIEW HighestInfectionCount as
SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM Project.coviddeaths
-- WHERE location like '%states%';
GROUP BY location, population
ORDER BY PercentPopulationInfected desc;

-- CREATING VIEW TOTAL CASES VS POPULATION SHOWS WHAT PERCEBTAGE OF POPULATION GOT COVID
CREATE VIEW PercentPopulationInfected as
SELECT location, date, population,total_cases, (total_cases/population)*100 as PercentPopulationInfected
FROM Project.coviddeaths
WHERE location like '%states%';

-- CREATE VIEW LOOKING AT THE TOTAL CASES VS TOTAL DEATHS SHOWS LIKELIHOOD OF DYING IF YOU CONTRACT COVID IN US
CREATE VIEW DeathPercentage as
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM Project.coviddeaths
WHERE location like '%states%'
AND continent is not null;
