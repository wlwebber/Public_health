* Encoding: UTF-8.
Author: W. Webber
Date: March 16, 2019
Data Source: California Health Interview Survey (CHIS), 2007 (Adult)
Description: This code defines new variables for physical activity, and analyzes the percentage of adults in CA overall and by race/ethnicity that
meet the CDC physical activity recommendations from 2007. Also, illustrates the following functions: (1) Read in data, (2) Manipulate data, 
(3) Analyze data, and (4) Export data.**

 **(1) Read in data: Open SPSS data file for 2007 CHIS Adult.**
  
GET
  FILE='C:\Users\Whitney\Desktop\SPSS Code\CHIS 2007\ADULT.sav'.
DATASET NAME DataSet2 WINDOW=FRONT.

**(2) Manipulate data: Compute new variable for percentage of adults who met CDC recommendations for aerobic physical activity.  In 2007, the recommendation from the Centers for Disease Control and Prevention (CDC) was that adults ages 18 and 
older should get at least 150 minutes of moderate intensity aerobic activity every week, 75 minutes of vigorous intensity, or a combination thereof.**

**Review variables of interest and code missing values.**

FREQUENCIES VARIABLES=AE25 AE25A AE27 AE27A RACEHPR2
  /ORDER=ANALYSIS.

MISSING VALUES AE25 AE25A AE27 AE27A (-1).

FREQUENCIES VARIABLES=AE25 AE25A AE27 AE27A
  /ORDER=ANALYSIS.

**Create variable for minutes of vigorous physical activity per week.**

COMPUTE VIGDAY=AE25.
IF (AE25AUNT=1) VIGWEEK = VIGDAY*AE25A.
IF (AE25AUNT=2) VIGWEEK = VIGDAY*AE25A*60.
EXECUTE.

**Create variable for minutes of moderate physical activity per week.**

COMPUTE MODDAY=AE27.
IF (AE27AUNT=1) MODWEEK = MODDAY*AE27A.
IF (AE27AUNT=2) MODWEEK = MODDAY*AE27A*60.
EXECUTE.

**Calculate new variable for total minutes of moderate physical activity per week.**

RECODE VIGWEEK (SYSMIS=0).
EXECUTE.

RECODE MODWEEK (SYSMIS=0).
EXECUTE.

COMPUTE TOTALMODPA = VIGWEEK*2 + MODWEEK.

FREQUENCIES VARIABLES=VIGWEEK MODWEEK TOTALMODPA
  /ORDER=ANALYSIS.

**Compute variable that indicates if the CDC physical activity recommendation was met.**

COMPUTE MEETSPA = 1.
IF TOTALMODPA LT 150 MEETSPA = 2. 

VALUE LABELS MEETSPA 1 'MEETS CDC PHYSICAL ACTIVITY RECOMMENDATION' 2 'DOES NOT MEET CDC PHYSICAL ACTIVITY RECOMMENDATION'.

FREQUENCIES VARIABLES=MEETSPA
  /ORDER=ANALYSIS.

**(3) Analyze data: Analyze the percentage of California adults who met the CDC physical activity recommendation. Analyze by race/ethnicity.**

FREQUENCIES VARIABLES=MEETSPA
  /ORDER=ANALYSIS.

CROSSTABS
  /TABLES=RACEHPR2 BY MEETSPA
  /FORMAT=AVALUE TABLES
  /CELLS=COUNT ROW 
  /COUNT ROUND CELL.

**(4) Export data.**

OUTPUT EXPORT
  /CONTENTS  EXPORT=ALL  LAYERS=PRINTSETTING  MODELVIEWS=PRINTSETTING
  /PDF  DOCUMENTFILE='C:\Users\Whitney\Desktop\SPSS Code\OUTPUT.pdf'
     EMBEDBOOKMARKS=YES  EMBEDFONTS=YES.
