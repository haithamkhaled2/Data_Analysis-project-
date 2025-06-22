select * 
from layoffs ;

with Layoffs_cte as (
select * , row_number() over(partition by company , location , company ,location ,industry
 ,total_laid_off ,percentage_laid_off ,`date` ,stage ,country ,funds_raised_millions) as row_num
 from layoffs 
)
select * 
from layoffs_cte ;
-- using copy to clipbord option from lyoffs table to copy the columns 
CREATE TABLE `layoffs2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` double DEFAULT NULL,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoffs2 
with Layoffs_cte as (
select * , row_number() over(partition by company , location , company ,location ,industry
 ,total_laid_off ,percentage_laid_off ,`date` ,stage ,country ,funds_raised_millions) as row_num
 from layoffs 
)
select * 
from layoffs_cte ;

select * from layoffs2
where row_num > 1;
delete from layoffs2
where row_num > 1 ;

Select distinct company , trim(company)
from layoffs2;

update layoffs2
set company = trim(company);

select industry
from layoffs2 
where industry like "Crypto%"; 
update layoffs2
set industry = 'Crypto'
where industry like "Crypto%";

select * from layoffs2
where ( total_laid_off is null or total_laid_off = '' ) 
and (percentage_laid_off is null or  percentage_laid_off = '' )  ;

delete from layoffs_cleaned 
where total_laid_off is null
and percentage_laid_off is null 
and funds_raised_millions is null ;

select * from layoffs2
where industry is null or industry = '' ;
select * from layoffs2
where company is null or company = '' ;

delete from layoffs2
where industry is null ;

select l1.industry , l2.industry from layoffs2 l1
join layoffs2 l2 on l1.company = l2.company
where ( l1.industry is null or l1.industry = '' )
and l2.industry is not null ;

update layoffs2
set industry = null 
where industry ='';

update layoffs2 l1 
join layoffs2 l2 on l1.company = l2.company
set l1.industry = l2.industry 
where l1.industry is null 
and l2.industry is not null;

select `date` , str_to_date(`date` , '%m/%d/%Y')
from layoffs2;
update layoffs2
set `date` = str_to_date(`date` , '%m/%d/%Y');





with Layoffs_cte as (
select * , row_number() over(partition by company , location , company ,location ,industry
 ,total_laid_off ,percentage_laid_off ,`date` ,stage ,country ,funds_raised_millions, row_num) as row_num2
 from layoffs2
)
select * 
from layoffs_cte ;

CREATE TABLE `layoffs_cleaned` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` double DEFAULT NULL,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int DEFAULT NULL,
  `row_num2` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoffs_cleaned
with Layoffs_cte as (
select * , row_number() over(partition by company , location , company ,location ,industry
 ,total_laid_off ,percentage_laid_off ,`date` ,stage ,country ,funds_raised_millions, row_num) as row_num2
 from layoffs2
)
select * 
from layoffs_cte ;

delete from layoffs_cleaned 
where row_num2 > 1 ;

select * from layoffs_cleaned;

alter table layoffs_cleaned 
drop Column row_num,
drop column row_num2 ;

select * from layoffs_cleaned 
where company ='' or location ='' or company ='' or location =''or industry =''
  or total_laid_off =''or percentage_laid_off =''or `date` =''or stage =''or country ='' or funds_raised_millions ='' ;

select * from layoffs_cleaned 
where industry like  'Crypto%'