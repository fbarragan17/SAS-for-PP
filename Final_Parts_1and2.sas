/*##########################
	Part 1 Reading Output and Code
  ########################## */

/*Loan Approvals*/

libname Final "/home/u60709958/SAS HW/Final";

/*
1. What Loan Approval status is being modeled?
Loan approved=0 
2. Which mortgage application type (Proper name of the type) is the reference category?
* referencing MortApp 5 = Other ;
3. Is the relationship between Credit Score and Loan approval significant at the 
   .05 level?
no it is significant
4. How do you know?
We have a p-value .3144
5. If the Purchase Price goes up what would you expect to happen to the probability of 
   Approval?
The probability of approval goes down 
*/
proc logistic data=Final.loanapp;
	class loanpurp mortapp /param=reference;
	model loanapproved = loanpurp mortapp creditscore price;
run;


/*
6. Is there a significant difference between GPA of section 1 and section 2?
Yes
7. Which P-Value did you use to determine significance?
0.0104
8. Why?
This tells us if there is a difference between the two groups. The value is > .05 p-value
9. Which Section has the higher GPA?
section 1
*/
proc ttest data=Final.study_gpa;
	class section;
	var GPA;
run;


/*
10.Which age group experienced the highest rate of Low Birth Weight?
group 1
11.What percentage of drinkers have babies with Low Birth Weight?
7.13 %
*/
proc freq data=Final.birthwgt;
	table Drinking * lowbirthwgt;
	table AgeGroup * lowbirthwgt;
run;


/*
12.What variables are significantly associated with Plaque?
HDL
13.What is the correlation coeffecient for LDL and HDL?
-.01074
14. What is the p-value of the correlation between Triglycerides and Systolic Blood Pressure?
.2062
15.Given this output, how would characterize the correlation between LDL cholesterol
   and Systolic Blood Pressure?
   a. N0 correlation 
*/
proc corr data=Final.vite;
	var plaque sbp ldl hdl trig;
run;

/*
16.Which continent has the lowest average population among its countries?
OC
17.Which continent has the highest proportion of observations in the dataset (i.e. the 
   continent with the most countries with an estimated population in the dataset)?
AF
18.What statistic should be requested on the TABLE statement to obtain each continent's
   proportion of the world's population in 2013?
pcntsum
*/
proc tabulate data=Final.population;
	class Continent;
	Variable y1 y2 y3 y4;
	table Continent, Y1*(ColPctN Mean Max);
run;

/*
Given values (val1, val2, val3), what will be the outputs (outp1, outp2, outp3, outp4)?

val1 =Santa Clara County, California, United States
val2 =Nebraska City, NE
val3 =today()-30
*/

data question_3;
	set _null_;
	outp1 = scan(val1,4,",");
	outp2 = index(val2,"NE");
	outp3 = month(val3);
	outp4 = index(upcase(val2),"NE");
run;
/*
19.outp1: " "
20.outp2: 16
21.outp3: 2
22.outp4: 1
*/

/*
23.What type of transpose is this?
long to wide
*/
proc sort data=Final.aveprices out=aveprices nodupkey;
	by year month commodity;
run;
proc transpose data=aveprices out=dataset_n;
	by year month;
	id commodity;
	var price;
run;

/*
24.What will happen if you specify TRANSPARENCY = 1 in a plot statement in 
   PROC SGPLOT? Makes them opaque, no color
25.What data set option will not impact which observations will be read into a SAS data
   set? (SELECT ALL THAT APPLY)
   DROP=
*/

proc corr data=lines;
	var CR25 CR75 M25 M75;
	with GPA;
run;

/*
26.How many different correlations will be calculated with the following PROC CORR?
4
*/



/*##########################
	Part 2 Analyzing Code
  ########################## */

/*See Questions at the bottom*/ 
proc contents data=sashelp.cars;

data cars01;
	set Final.cars;
/*Section 1*/
		if msrp >=40000 then highprice_car = 1;
		else if msrp >= 0 then highprice_car = 0;
		
		if mpg_highway >32 then efficient_mileage_car = 1;
		else if mpg_highway <= 32 then efficient_mileage_car = 0;
run;

/*Section 2*/
%let carvars = msrp highprice_car mpg_city mpg_highway efficient_mileage_car;

%macro bad_macro_name;
/*Section 3*/
%do x=1 %to 5;
	%let var=%scan(&carvars, &x, " ");
/*End Section 3*/

/*Section 4*/
	%if &x = 2 | &x =5 %then %do;
		proc logistic data=cars01;
			title "bad title 2";
			title2 "Model &x: ";
			class origin drivetrain;
			model &var (event='1') =weight enginesize horsepower length origin drivetrain;
		run;
		quit;
	%end;
/*End Section 4*/

/*Section 5*/
	%else %do;
		proc glm data=cars01;
			title "bad title 1";
			title2 "Model &x: ";
			class origin drivetrain;
			model &var = weight enginesize horsepower length origin drivetrain/solution;
		run;
		quit;
	%end;
/*End Section 5*/
%end;
%mend;

/*Section 6*/
%bad_macro_name;
	
/*
1. What kind of variables are being created in Section 1? Numeric or Character? 
   If numeric, continuous, ordinal or binary?
numeric, binary
2. Is the macro variable created in Section 2, GLOBAL or LOCAL?
global
3. What is happening in Section 3?
setting up a do loop to scan the 5 variables by a space in carvars

4. Explain the logic that occurs in Section 4.
while it does the loop, if its the 2nd or 5th item in carvars it will run a proc logistic with the assignments below.
For example it will take the 2nd variable in carvar which is highprice_car and replace it where &var is
the model is will be high_price_car (event='1') = weight enginesize ... 
Similar procedue for the 5th variable in carvars

5. If Section 6 is submitted, how many regression models will be output?
5 models

6. Why might the two types of regression models be used in this case?
   HINT: What do the variables 2 and 5 have in common that the others do not?
chi square or proc logistic, both variables are categorical

7. When x is equal to 3, what will be the exact text in the TITLE2 statement?
Model 3: 

8. If Sections 1 through 5 are submitted, how many new datasets are produced?
1
*/
