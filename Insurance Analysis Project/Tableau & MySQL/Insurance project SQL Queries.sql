create database insurance_analytics;
use insurance_analytics;
show tables;
desc brokerage;
select * from brokerage;
select count(policy_number) from brokerage;
select income_class, sum(amount) from brokerage
group by income_class;
show tables;
desc fees;
select * from fees;
Drop table fees;
show tables;
select income_class, sum(amount) 
from fees
group by income_class;
select sum(`New Budget`),sum(`Cross sell bugdet`), sum(`Renewal Budget`)
from `individual budget`;
Alter table `individual budget` rename column `Cross sell bugdet` to ` Cross Sell Budget`;
desc `individual budget`; 
select * from `individual budget`;
Alter table `individual budget` rename column ` Cross Sell Budget` to `Cross Sell Budget` ;
select count(invoice_number)
from invoice;
show tables;
desc meeting;
use sampledb;
use insurance_analytics;
show tables;
desc meeting;
alter table meeting modify column `Account Exe ID` text;
desc invoice;
desc brokerage;
alter table brokerage rename column `Account Exe ID` to `Account Executive`;
alter table brokerage rename column `Account Id` to `Account Exe ID`;
desc opportunity;
alter table opportunity modify column `Account Exe Id` text;

create database insurance_analytics;
use insurance_analytics;
show tables;
desc brokerage;
select * from brokerage;

create table `brokerage_new` as
(select `Account Exe ID`, `Account Executive`, `income_class`, sum(Amount) as `Total_Amount`
from brokerage 
group by 1,2,3);

select * from `brokerage_new`;

select `Account Exe ID`, `Account Executive`, `income_class`, `Total_Amount`
from `brokerage_new`
where `Account Exe ID`=3;

select * from invoice;
desc invoice;

create table `invoice_new` as
(select `invoice_number`, `Account Exe ID`, `Account Executive`, `income_class`, sum(Amount) as `Total_Invoice_Amount`
from invoice
group by 1,2,3,4);

select * from `invoice_new`;

desc `individual budget`;
select * from `individual budget`;

create table `individual budget_new` as
(select `Sales person ID`, `Employee Name`, `New Budget`,`Cross Sell Budget`,`Renewal Budget`
from `individual budget`);
select * from `individual budget_new`;

select * from fees;
create table `fee_new` as
(select `Salesperson ID`, `Account Executive`, `income_class`, sum(amount) as `Total_Fees`
from fees
group by 1,2,3);

select * from `fee_new`;