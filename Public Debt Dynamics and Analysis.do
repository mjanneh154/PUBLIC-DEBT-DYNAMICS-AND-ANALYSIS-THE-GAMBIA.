clear all
log using fiscal.log, replace
*IMPORT DATA
pwd
cd"C:\Users\H P\PyCharmMiscProject"
dir

import delimited  "gambia_fiscal2.csv"

*INSPECT THE DATASET
browse
describe debt_gdp

*SUMMARIZE DATA
summarize
summarize debt_gdp, detail
inspect debt_gdp

*MISSING VALUE AND CLEANING
misstable summarize
drop v1

*DECLARE TIME SERIES DATA 
tsset year
tsline debt_gdp
tsline debt_gdp_change
tsline expenditure_gdp
tsline revenue_gdp
tsline exchange_rate_gmd_per_usd
tsline gdp_growth
dfuller gdp_growth


*CHECK FOR STATIONARITY
dfuller debt_gdp_change
dfuller debt_gdp
dfuller inflation
dfuller gdp_growth
dfuller primary_balance_gdp
dfuller exchange_rate_gmd_per_usd
tsline primary_balance_gdp

*MAKE THE FOLLOWING VARIABLES STATIONARY BY DIFFERENCING
gen d_inflation = D.inflation
gen d_debt_gdp = D.debt_gdp
gen d_expenditure_gdp = D.expenditure_gdp
gen d_revenue_gdp = D.revenue_gdp
gen d_exchange = D.exchange_rate_gmd_per_usd

*CHECK FOR STATIONARITY AGAIN
tsline d_inflation
dfuller d_inflation
tsline d_debt_gdp
dfuller d_debt_gdp
tsline d_revenue_gdp
tsline d_expenditure_gdp
tsline d_exchange
dfuller d_exchange
*Now that our variables are Stationary, we move to Timeseries regression analysis. We first test for Autocorrelations and Partial Autocorrelations.

ac d_debt_gdp
pac d_debt_gdp

reg d_debt_gdp primary_balance_gdp gdp_growth d_inflation 

*BREUSCH-Godfrey Test
estat bgodfrey, lag(1)

*No Autocorrelations after the Godfrey Test

estat hettest
* After doing the breusch pagan test, we found out that our residuals are not constantly spread, which means there is hetroskedasticity present. W are going to do a robust standard error regression.

reg d_debt_gdp primary_balance_gdp gdp_growth d_inflation d_expenditure_gdp d_revenue_gdp d_exchange, robust

*Test for model specifications
estat ovtest

estat vif

ssc install estout
eststo clear

eststo model1: reg d_debt_gdp primary_balance_gdp gdp_growth d_inflation d_expenditure_gdp d_revenue_gdp d_exchange, robust

esttab model1, se




























*DROP MISIING VALUES CAUSED BY 