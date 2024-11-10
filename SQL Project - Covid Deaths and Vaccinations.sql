Select * from PortfolioProject.dbo.CovidVaccinations order by 3,4


Select Location, date, total_cases,new_cases,total_deaths,population
from PortfolioProject.dbo.CovidDeaths
order by 1,2

Select Location, date, total_cases,total_deaths,
(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject.dbo.CovidDeaths
Where location like '%states%'
order by 1,2

Select Location, date,population, total_cases,
(total_cases/population)*100 as Percent_Population_Infected
from PortfolioProject.dbo.CovidDeaths
Where location like '%states%'
order by 1,2


Select Location,population, Max(total_cases) as HighestInfectionCount,
MAX((total_cases/population))*100 as Percent_Population_Infected
from PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
Group by location, population
order by Percent_Population_Infected desc


--Showing Countries with Highest Death Count per population

Select Location, Max(cast(total_deaths as int)) as Total_Death_Count
--MAX((total_cases/population))*100 as Percent_Population_Infected
from PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
where continent is not null
Group by location
order by Total_Death_Count desc


--Sorting through Continent

Select location, Max(cast(total_deaths as int)) as Total_Death_Count
--MAX((total_cases/population))*100 as Percent_Population_Infected
from PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
where continent is null
Group by location
order by Total_Death_Count desc


--Showing Continents with the highest death count as per population

Select continent, Max(cast(total_deaths as int)) as Total_Death_Count
--MAX((total_cases/population))*100 as Percent_Population_Infected
from PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
where continent is not null
Group by continent
order by Total_Death_Count desc


-- Global Numbers and calculations

Select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
where continent is not null
--group by date
order by 1,2


--Total Population vs Vaccinations

Select D.continent,	D.location, D.date, D.population, V.new_vaccinations, 
SUM(CONVERT(int, V.new_vaccinations)) OVER (Partition by D.location order by D.location, D.date) as R_People_Vaccinated
--,(R_People_Vaccinated/population)*100
from PortfolioProject..CovidDeaths D
join PortfolioProject..CovidVaccinations V
on D.location = V.location
and D.date = V.date
where D.continent is not null
order by 1,2,3


--TEMP TABLE 
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric)

Insert into #PercentPopulationVaccinated
Select D.continent,	D.location, D.date, D.population, V.new_vaccinations, 
SUM(CONVERT(int, V.new_vaccinations)) OVER (Partition by D.location order by D.location, D.date) as RollingPeopleVaccinated
--,(R_People_Vaccinated/population)*100
from PortfolioProject..CovidDeaths D
join PortfolioProject..CovidVaccinations V
on D.location = V.location
and D.date = V.date
where D.continent is not null
order by 1,2,3

Select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated


--Creating View to store data for later visualizations
Create view PercentPopulationVaccinated as
Select D.continent,	D.location, D.date, D.population, V.new_vaccinations, 
SUM(CONVERT(int, V.new_vaccinations)) OVER (Partition by D.location order by D.location, D.date) as RollingPeopleVaccinated
--,(R_People_Vaccinated/population)*100
from PortfolioProject..CovidDeaths D
join PortfolioProject..CovidVaccinations V
on D.location = V.location
and D.date = V.date
where D.continent is not null
--order by 1,2,3

Select * from PercentPopulationVaccinated