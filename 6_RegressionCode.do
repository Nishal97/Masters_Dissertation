clear all
cd "C:\Users\Nish\OneDrive - University of Bristol\Dissertation\Volume Forecasting\Data\Regression"
import delimited "STATAData.csv", clear

//ssc install xtqreg, replace
//ssc install estout, replace
//ssc install qregplot, replace
//ssc install ftools, replace

///DECLARE PANEL///
egen asset_id = group(asset)
xtset asset_id week

////////////////////////////////////////////////////////////////////////////////

///VARIABLE GENERATION///
gen lag_sentiment = L.ave_sentiment
gen lag2_sentiment = L2.ave_sentiment
gen lag3_sentiment = L3.ave_sentiment
gen dsentiment = d.ave_sentiment

gen lag_vol = L.logvol
gen lag2_vol = L2.logvol
gen lag3_vol = L3.logvol

gen Dsubmissions = d.submissions
gen sum_submissions = L.submissions+L2.submissions+L3.submissions
gen lag_submissions  =  L.submissions
gen lag_submissions2 = L2.submission 
gen lag_submissions3 = L3.submission 

gen avret_lag = L.avret

gen stdev_lag = L.stdev

gen autocov_lag = L.autocov

gen dvol  = d.logvol


export delimited using "C:\Users\Nish\OneDrive - University of Bristol\Dissertation\Volume Forecasting\Data\Regression\STATAData2.csv", replace

////////////////////////////////////////////////////////////////////////////////

import delimited "STATADataTop30.csv", clear
egen asset_id = group(asset)
xtset asset_id week

gen lag_sentiment = L.ave_sentiment
gen lag2_sentiment = L2.ave_sentiment
gen lag3_sentiment = L3.ave_sentiment
gen dsentiment = d.ave_sentiment

gen lag_vol = L.logvol
gen lag2_vol = L2.logvol
gen lag3_vol = L3.logvol

gen Dsubmissions = d.submissions
gen sum_submissions = L.submissions+L2.submissions+L3.submissions
gen lag_submissions =L.submissions 

gen avret_lag = L.avret

gen stdev_lag = L.stdev

gen autocov_lag = L.autocov

gen dvol = d.logvol

export delimited using "C:\Users\Nish\OneDrive - University of Bristol\Dissertation\Volume Forecasting\Data\Regression\STATADataTop30.csv", replace

////////////////////////////////////////////////////////////////////////////////

import delimited "STATADataMid30.csv", clear
egen asset_id = group(asset)
xtset asset_id week

gen lag_sentiment = L.ave_sentiment
gen lag2_sentiment = L2.ave_sentiment
gen lag3_sentiment = L3.ave_sentiment
gen dsentiment = d.ave_sentiment

gen lag_vol = L.logvol
gen lag2_vol = L2.logvol
gen lag3_vol = L3.logvol

gen Dsubmissions = d.submissions
gen sum_submissions = L.submissions+L2.submissions+L3.submissions
gen lag_submissions =L.submissions 

gen avret_lag = L.avret

gen stdev_lag = L.stdev

gen autocov_lag = L.autocov

gen dvol = d.logvol

export delimited using "C:\Users\Nish\OneDrive - University of Bristol\Dissertation\Volume Forecasting\Data\Regression\STATADataMid30.csv", replace

////////////////////////////////////////////////////////////////////////////////

import delimited "STATADataBottom30.csv", clear
egen asset_id = group(asset)
xtset asset_id week

gen lag_sentiment = L.ave_sentiment
gen lag2_sentiment = L2.ave_sentiment
gen lag3_sentiment = L3.ave_sentiment
gen dsentiment = d.ave_sentiment

gen lag_vol = L.logvol
gen lag2_vol = L2.logvol
gen lag3_vol = L3.logvol

gen Dsubmissions = d.submissions
gen sum_submissions = L.submissions+L2.submissions+L3.submissions
gen lag_submissions =L.submissions 

gen avret_lag = L.avret

gen stdev_lag = L.stdev

gen autocov_lag = L.autocov

gen dvol = d.logvol

export delimited using "C:\Users\Nish\OneDrive - University of Bristol\Dissertation\Volume Forecasting\Data\Regression\STATADataBottom30.csv", replace

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
import delimited "STATAData2.csv", clear
xtset asset_id week

///IPS tests for unit root///
xtunitroot ips lag_sentiment if asset_id, lags(aic)
///Reject Null at all levels - volume = stationary

xtunitroot ips dsubmissions if asset_id, lags(aic)
///Reject Null at all levels - sentiment = stationary

xtunitroot ips lag_vol if asset_id, lags(aic)
///Reject Null at all levels - sentiment = stationary

xtunitroot ips stdev_lag if asset_id, lags(aic)
///Reject Null at all levels - sentiment = stationary

xtunitroot ips autocov if asset_id, lags(aic)
///Reject Null at all levels - sentiment = stationary


////////////////////////////////////////////////////////////////////////////////


////*******************************ANALYSIS 1*******************************//// 
//USING LAGS OF SENTIMENTS AND SUBMISSIONS TO PREDICT NEXT WEEK - REPLICATION// 

////////////////////////////////////////////////////////////////////////////////
cd "C:\Users\Nish\OneDrive - University of Bristol\Dissertation\Volume Forecasting\Data\Regression"

///TOP30///
import delimited "STATAdataTop30.csv", clear
xtset asset_id week
local predictors `"lag_sentiment dsubmissions lag_vol stdev_lag autocov"' 
	///Mean Regression
	quietly xtreg logvol `predictors', fe
	eststo model0
	///Quantile Regression
	quietly xtqreg logvol `predictors', quantile(0.1) i(asset_id)
	eststo model1
	quietly xtqreg logvol `predictors', quantile(0.2) i(asset_id)
	eststo model2
	quietly xtqreg logvol `predictors', quantile(0.4) i(asset_id)
	eststo model3
	quietly xtqreg logvol `predictors', quantile(0.5) i(asset_id)
	eststo model4
	quietly xtqreg logvol `predictors', quantile(0.6) i(asset_id)
	eststo model5
	quietly xtqreg logvol `predictors', quantile(0.8) i(asset_id)
	eststo model6
	quietly xtqreg logvol `predictors', quantile(0.9) i(asset_id)
	eststo model7
	
	esttab using A1.tex, se label title(Table A1) nonumbers mtitles("OLS" "0.1" "0.2" "0.4" "0.5" "0.6" "0.8" "0.9") compress replace
	eststo clear
********************************************************************************
	quietly xtqreg logvol `predictors', quantile(0.1(0.1)0.9) i(asset_id)
	qregplot, ols olsopt(abs(asset_id) robust) q(10(10)90) raopt(color(gs14))
********************************************************************************

////////////////////////////////////////////////////////////////////////////////	
	
///MID30//
import delimited "STATAdataMid30.csv", clear
xtset asset_id week
local predictors `"lag_sentiment dsubmissions lag_vol stdev_lag autocov"' 

	///Mean Regression
	quietly xtreg logvol `predictors', fe
	eststo model0
	///Quantile Regression
	quietly xtqreg logvol `predictors', quantile(0.1) i(asset_id)
	eststo model1
	quietly xtqreg logvol `predictors', quantile(0.2) i(asset_id)
	eststo model2
	quietly xtqreg logvol `predictors', quantile(0.4) i(asset_id)
	eststo model3
	quietly xtqreg logvol `predictors', quantile(0.5) i(asset_id)
	eststo model4
	quietly xtqreg logvol `predictors', quantile(0.6) i(asset_id)
	eststo model5
	quietly xtqreg logvol `predictors', quantile(0.8) i(asset_id)
	eststo model6
	quietly xtqreg logvol `predictors', quantile(0.9) i(asset_id)
	eststo model7
	
	esttab using A2.tex, se label title(Table A2) nonumbers mtitles("OLS" "0.1" "0.2" "0.4" "0.5" "0.6" "0.8" "0.9") compress replace booktabs
	eststo clear
********************************************************************************	
	quietly xtqreg logvol `predictors', quantile(0.1(0.1)0.9) i(asset_id)
	qregplot, ols olsopt(abs(asset_id) robust) q(10(10)90) raopt(color(gs14))
********************************************************************************

////////////////////////////////////////////////////////////////////////////////	

///BOTTOM30//
import delimited "STATAdataBottom30.csv", clear
xtset asset_id week 
local predictors `"lag_sentiment dsubmissions lag_vol stdev_lag autocov"' 

	///Mean Regression
	quietly xtreg logvol `predictors', fe
	eststo model0
	///Quantile Regression
	quietly xtqreg logvol `predictors', quantile(0.1) i(asset_id)
	eststo model1
	quietly xtqreg logvol `predictors', quantile(0.2) i(asset_id)
	eststo model2
	quietly xtqreg logvol `predictors', quantile(0.4) i(asset_id)
	eststo model3
	quietly xtqreg logvol `predictors', quantile(0.5) i(asset_id)
	eststo model4
	quietly xtqreg logvol `predictors', quantile(0.6) i(asset_id)
	eststo model5
	quietly xtqreg logvol `predictors', quantile(0.8) i(asset_id)
	eststo model6
	quietly xtqreg logvol `predictors', quantile(0.9) i(asset_id)
	eststo model7
	
	esttab using A3.tex, se label title(Table A3) nonumbers mtitles("OLS" "0.1" "0.2" "0.4" "0.5" "0.6" "0.8" "0.9") compress replace booktabs
	eststo clear
********************************************************************************
	quietly xtqreg logvol `predictors', quantile(0.1(0.1)0.9) i(asset_id)
	qregplot, ols olsopt(abs(asset_id) robust) q(10(10)90) raopt(color(gs14))
********************************************************************************

////////////////////////////////////////////////////////////////////////////////

///WHOLE SAMPLE//
import delimited "STATAData2.csv", clear
xtset asset_id week
local predictors `"lag_sentiment dsubmissions lag_vol stdev_lag autocov"'

///drop if asset_id == 42 | asset_id == 7 | asset_id == 15 | asset_id == 91
	///Mean Regression
	quietly xtreg logvol `predictors', fe
	eststo model0
	///Quantile Regression
	quietly xtqreg logvol `predictors', quantile(0.1) i(asset_id)
	eststo model1
	quietly xtqreg logvol `predictors', quantile(0.2) i(asset_id)
	eststo model2
	quietly xtqreg logvol `predictors', quantile(0.4) i(asset_id)
	eststo model3
	quietly xtqreg logvol `predictors', quantile(0.5) i(asset_id)
	eststo model4
	quietly xtqreg logvol `predictors', quantile(0.6) i(asset_id)
	eststo model5
	quietly xtqreg logvol `predictors', quantile(0.8) i(asset_id)
	eststo model6
	quietly xtqreg logvol `predictors', quantile(0.9) i(asset_id)
	eststo model7
	
	esttab using A4.tex, se label title(Table A4) nonumbers mtitles("OLS" "0.1" "0.2" "0.4" "0.5" "0.6" "0.8" "0.9") compress replace
	eststo clear
********************************************************************************
	quietly xtqreg `predictors' , quantile(0.1(0.1)0.9) i(asset_id) 
	qregplot, ols olsopt(abs(asset_id) robust) q(10(10)90) raopt(color(gs14))
********************************************************************************

////////////////////////////////////////////////////////////////////////////////
///////////////////////////////Robust Testing 1/////////////////////////////////

/*restricting the sample to assets with greater than 200 submissions*/

import delimited "STATAData2.csv", clear
xtset asset_id week
local predictors `"lag_sentiment dsubmissions lag_vol stdev_lag autocov"'

gen expsub = exp(submissions)
bys asset_id: egen sumsub = sum(expsub)
drop if sumsub < 200

///drop if asset_id == 42 | asset_id == 7 | asset_id == 15 | asset_id == 91
	///Mean Regression
	quietly xtreg logvol `predictors', fe
	eststo model0
	///Quantile Regression
	quietly xtqreg logvol `predictors', quantile(0.1) i(asset_id)
	eststo model1
	quietly xtqreg logvol `predictors', quantile(0.2) i(asset_id)
	eststo model2
	quietly xtqreg logvol `predictors', quantile(0.4) i(asset_id)
	eststo model3
	quietly xtqreg logvol `predictors', quantile(0.5) i(asset_id)
	eststo model4
	quietly xtqreg logvol `predictors', quantile(0.6) i(asset_id)
	eststo model5
	quietly xtqreg logvol `predictors', quantile(0.8) i(asset_id)
	eststo model6
	quietly xtqreg logvol `predictors', quantile(0.9) i(asset_id)
	eststo model7
	
	esttab using A5.tex, se label title(Table A4) nonumbers mtitles("OLS" "0.1" "0.2" "0.4" "0.5" "0.6" "0.8" "0.9") compress replace
	eststo clear

////////////////////////////////////////////////////////////////////////////////
///////////////////////////////Robust Testing 2/////////////////////////////////

/*Removing assets which represent adverse events*/

import delimited "STATAData2.csv", clear
xtset asset_id week
local predictors `"lag_sentiment dsubmissions lag_vol stdev_lag autocov"'

drop if asset_id == 42 | asset_id == 7 | asset_id == 15 | asset_id == 91
	///Mean Regression
	quietly xtreg logvol `predictors', fe
	eststo model0
	///Quantile Regression
	quietly xtqreg logvol `predictors', quantile(0.1) i(asset_id)
	eststo model1
	quietly xtqreg logvol `predictors', quantile(0.2) i(asset_id)
	eststo model2
	quietly xtqreg logvol `predictors', quantile(0.4) i(asset_id)
	eststo model3
	quietly xtqreg logvol `predictors', quantile(0.5) i(asset_id)
	eststo model4
	quietly xtqreg logvol `predictors', quantile(0.6) i(asset_id)
	eststo model5
	quietly xtqreg logvol `predictors', quantile(0.8) i(asset_id)
	eststo model6
	quietly xtqreg logvol `predictors', quantile(0.9) i(asset_id)
	eststo model7
	
	esttab using A6.tex, se label title(Table A4) nonumbers mtitles("OLS" "0.1" "0.2" "0.4" "0.5" "0.6" "0.8" "0.9") compress replace
	eststo clear

////////////////////////////////////////////////////////////////////////////////
///////////////////////////////Robust Testing 3/////////////////////////////////

/*Introducing an interaction term*/

import delimited "STATAData2.csv", clear
xtset asset_id week
gen interact = lag_sentiment*dsubmissions
local predictors `"interact lag_sentiment dsubmissions lag_vol stdev_lag autocov"'

drop if asset_id == 42 | asset_id == 7 | asset_id == 15 | asset_id == 91
	///Mean Regression
	quietly xtreg logvol `predictors', fe
	eststo model0
	///Quantile Regression
	quietly xtqreg logvol `predictors', quantile(0.1) i(asset_id)
	eststo model1
	quietly xtqreg logvol `predictors', quantile(0.2) i(asset_id)
	eststo model2
	quietly xtqreg logvol `predictors', quantile(0.4) i(asset_id)
	eststo model3
	quietly xtqreg logvol `predictors', quantile(0.5) i(asset_id)
	eststo model4
	quietly xtqreg logvol `predictors', quantile(0.6) i(asset_id)
	eststo model5
	quietly xtqreg logvol `predictors', quantile(0.8) i(asset_id)
	eststo model6
	quietly xtqreg logvol `predictors', quantile(0.9) i(asset_id)
	eststo model7
	
	esttab using A7.tex, se label title(Table A4) nonumbers mtitles("OLS" "0.1" "0.2" "0.4" "0.5" "0.6" "0.8" "0.9") compress replace
	eststo clear

////////////////////////////////////////////////////////////////////////////////

/////////////////////////Summary Statistics/////////////////////////////////////
import delimited "STATAData2.csv", clear
xtset asset_id week

histogram logvol, frequency normal