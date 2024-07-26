use covid;
show tables;
describe covid_deaths;
describe covid_vaccinations;
;
DROP VIEW continent_year_population;
CREATE VIEW continent_year_population AS
WITH aux_table AS (SELECT continent, iso_code,DATE_FORMAT(STR_TO_DATE(date,'%c/%e/%Y'),'%Y') as year, AVG(population) AS population FROM covid_deaths
GROUP BY iso_code, year, continent)
SELECT at.continent, at.year, SUM(population) as population
FROM aux_table AS at
GROUP BY at.continent, at.year;


CREATE VIEW total_population AS
SELECT cyp.continent, ROUND(AVG(cyp.population)) as population 
FROM continent_year_population AS cyp
GROUP BY continent;

CREATE VIEW total_vaccinated_population AS
SELECT continent, MAX(people_fully_vaccinated) as people_fully_vaccinated, DATE_FORMAT(STR_TO_DATE(date,'%c/%e/%Y'),'%Y') AS year 
FROM covid_vaccinations
GROUP BY continent, year
HAVING year = 2023;
SHOW TABLES;

CREATE VIEW rate AS
WITH death_total_population AS
(
    WITH deaths AS (
    SELECT continent, MAX(total_deaths) as total_deaths, DATE_FORMAT(STR_TO_DATE(date,'%c/%e/%Y'),'%Y') AS year 
    FROM covid_deaths
    GROUP BY continent, year
    HAVING year = 2023)
SELECT tp.continent, tp.population, ds.total_deaths, ROUND((ds.total_deaths/tp.population)*100,4) AS death_rate
FROM total_population AS tp
JOIN deaths AS ds
ON tp.continent = ds.continent
)SELECT tvp.continent, dtp.population, tvp.people_fully_vaccinated, dtp.total_deaths,dtp.death_rate, ROUND((tvp.people_fully_vaccinated/dtp.population)*100,4) AS vaccination_rate
FROM total_vaccinated_population AS tvp
JOIN death_total_population AS dtp
ON dtp.continent = tvp.continent;

SELECT location,AVG(people_fully_vaccinated) FROM covid_vaccinations WHERE continent='Oceania'
GROUP BY location
ORDER BY AVG(people_fully_vaccinated);
SET 


SELECT * FROM covid_vaccinations;

SELECT cv.continent,MAX(cv.people_fully_vaccinated) AS vacunaciones ,cs.population, cs.deaths, (MAX(cv.people_fully_vaccinated)/cs.population)*100 AS percentage_vac
FROM covid_vaccinations AS cv
JOIN continent_sorted AS cs
ON cs.continent = cv.continent
GROUP BY continent;

SELECT iso_code, continent, DATE_FORMAT(STR_TO_DATE(date,'%c/%e/%Y'),'%c/%Y'), AS date 
FROM covid_vaccinations;
-- ¿Cuál es la relación entre la tasa de vacunación y la tasa de mortalidad por COVID-19 en diferentes continentes?
SELECT * FROM covid_vaccinations AS cv
JOIN covid_deaths AS cd
ON cv.iso_code = cd.iso_code AND ;

-- ¿Cómo afectan la densidad de población y la edad media a las tasas de vacunación y mortalidad por COVID-19?
-- ¿Qué impacto tienen los factores socioeconómicos como el PIB per cápita y el índice de desarrollo humano en la tasa de vacunación y mortalidad por COVID-19?