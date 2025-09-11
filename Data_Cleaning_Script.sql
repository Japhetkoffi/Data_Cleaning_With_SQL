-- Netoyage des Données 

select*
from layoffs;

-- 1.Supprimer les douplons
-- 2.Standardiser les Données 
-- 3.Gestion des valeurs null et des cases vides 
-- 4.Suppression des colonnes et lignes moins pertinantes


-- Creer une copie des données
create table layoffs_1
like layoffs;
 
select*
from layoffs_1;

insert layoffs_1
select* 
from layoffs;

select*
from layoffs_1;

-- 1.Supprimer les doublons
select*,
row_number() over(
partition by company, location, industry, total_laid_off,percentage_laid_off,'date', stage, country, funds_raised_millions)as row_num
from layoffs_1;

with duplicate_cte as 
(
select*,
row_number() over(
partition by company, location, industry, total_laid_off,percentage_laid_off,'date', stage, country, funds_raised_millions)as row_num
from layoffs_1
)

select* 
from duplicate_cte
where row_num >1;

select* 
from layoffs_1
where company = 'Cazoo';

with duplicate_cte as 
(
select*,
row_number() over(
partition by company, location, industry, total_laid_off,percentage_laid_off,'date', stage, country, funds_raised_millions)as row_num
from layoffs_1
)
delete
from duplicate_cte
where row_num >1;

CREATE TABLE `layoffs_2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` double DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select* 
from layoffs_2;

insert into layoffs_2
select*,
row_number() over(
partition by company, location, industry, total_laid_off,percentage_laid_off,'date', stage, country, funds_raised_millions)as row_num
from layoffs_1;

delete
from layoffs_2
where row_num > 1;

select*
from layoffs_2
where row_num > 1;

select*
from layoffs_2;

-- 2.Standardiser les Données 
select company, trim(company)
from layoffs_2;

update layoffs_2
set company = trim(company);

select *
from layoffs_2
where industry like 'Crypto%';

update layoffs_2
set industry = 'Crypto'
where industry like 'Crypto%';

select *
from layoffs_2
where location = 'Florianópolis';

update layoffs_2
set location  = 'Florianópolis'
where location = 'FlorianÃ³polis';

select distinct location
from layoffs_2
order by 1;

select *
from layoffs_2
where location = 'MalmÃ¶';

update layoffs_2
set location  = 'Malmö'
where location = 'MalmÃ¶';

select distinct country
from layoffs_2
order by 1;

select *
from layoffs_2
where country = 'United States.';

update layoffs_2
set country  = 'United States'
where country = 'United States.';

-- Fixer le type date
select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_2;

update layoffs_2
set `date`  = str_to_date(`date`, '%m/%d/%Y');

select*
from layoffs_2;

alter table layoffs_2
modify column `date` date;

-- 3.Gestion des valeurs null et des cases vides 
select t1.industry, t2.industry
from layoffs_2 t1
join layoffs_2 t2
	on t1.company = t2.company
where (t1.industry is null)
and t2.industry is not null;

select*
from layoffs_2
where company = 'Airbnb';

update layoffs_2
set industry = null 
where industry = '';

update layoffs_2 t1
join layoffs_2 t2
	on t1.company = t2.company
set t1.industry = t2.industry 
where (t1.industry is null)
and t2.industry is not null;

select*
from layoffs_2
where industry is null or industry =''; -- vérification 

select*
from layoffs_2
where company like 'Bally%'; -- Cette valeur est unique

-- 4.Suppression des colonnes et lignes moins pertinantes 
select*
from layoffs_2
where total_laid_off is null
and percentage_laid_off is null;

delete
from layoffs_2
where total_laid_off is null
and percentage_laid_off is null;
 
select*
from layoffs_2;

alter table layoffs_2
drop row_num;
