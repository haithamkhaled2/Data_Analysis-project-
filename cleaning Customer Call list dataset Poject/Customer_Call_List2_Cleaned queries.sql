SELECT * FROM data_cleaning_project2.customer_call_list;

select CustomerID , Count(customerID) as count from customer_call_list
group by customerID ;
alter table customer_call_list add CustomerID int  primary kEY; 

select * , row_number() over( partition by CustomerID ,First_Name , Last_Name , Phone_Number
, Address , Do_Not_Contact )as row_num
from customer_call_list
CREATE TABLE `customer_call_list2` (
  `CustomerID` int DEFAULT NULL,
  `First_Name` text,
  `Last_Name` text,
  `Phone_Number` text,
  `Address` text,
  `Paying Customer` text,
  `Do_Not_Contact` text,
  `Not_Useful_Column` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

#insert into customer_call_list2
select * , row_number() over( partition by CustomerID ,First_Name , Last_Name , Phone_Number
, Address , Do_Not_Contact )as row_num
from customer_call_list;

delete from customer_call_list2
where row_num > 1 ;

select Last_Name from customer_call_list2;
Update customer_call_list2
set last_name =  TRIM(REGEXP_REPLACE(Last_Name, '[123.../_]', ''));

select * from customer_call_list2;

select phone_number , regexp_replace(phone_number, '[-/|]','' )as phone from customer_call_list2;

update customer_call_list2
set phone_number = regexp_replace(phone_number,'[-/\|]',''),
	phone_number = concat(substring(phone_number ,1,3),'-' ,
                          substring(phone_number,4,3),'-' ,
                          substring(phone_number,7),'');
Update customer_call_list2	
 set phone_number = null
 where phone_number IN ('NaN','na--' , '--' , 'nan') ;
 
-- update customer_call_list2 l1
  -- join customer_call_list l2 
  -- on l1.customerID = l2.customerID
 -- set l1.`Paying Customer`= l2.`Paying Customer`;
 select Phone_Number , Length(Phone_Number) as counting from customer_call_list2;
 
 select * from customer_call_list2;

Update customer_call_list2
set `Paying Customer` = trim(`Paying Customer`),
	`Paying Customer` = CASE 
    WHEN `Paying Customer` like 'Y%' THEN 'YES'
    WHEN `Paying Customer` = 'N/a' THEN ''
    WHen `Paying Customer` like'N%' THen 'NO'
    END;

Update customer_call_list2
set Do_Not_Contact = trim(Do_Not_Contact),
	Do_Not_Contact = CASE 
    WHEN Do_Not_Contact like 'Y%' THEN 'YES'
    WHen Do_Not_Contact like'N%' THen 'NO'
    END;
Alter Table customer_call_list2 
Add Steet_Address Varchar(100),
Add State varchar(50);

update customer_call_list2
set Steet_Address = Trim(substring_index(Address ,',',1)),
     State = CASE
        WHEN Address LIKE '%,%' THEN TRIM(SUBSTRING_INDEX(Address, ',', -1))
        ELSE ''
    END;

alter table customer_call_list2
drop column  Address ,
drop column Not_Useful_Column , 
drop column row_num;

delete from customer_call_list2
where phone_Number is null 
or Do_Not_Contact = 'YES'
