use "/Users/arnurakhat/Downloads/Bosaso-and-Mogadishu-Informal-2019-full-data-long-form.dta"
keep b9 b10 b1 b11 b2a l1a l1b ir1d n5a n5b n5c MICd2
rename b1 owners_number
rename b2a female
rename b9 owner_age
rename b10 owner_experience
rename MICd2 totsale
rename ir1d special_offer
generate total_estimate = n5a + n5b + n5c
label variable total_estimate "total_assets"
label variable total_estimate "Total assets of firm"
rename total_estimate total_assets
generate workers_num = l1a + l1b 
label variable workers_num "Number Of Workers In This Business "
label variable total_assets "Total Assets Of This Business"
 keep owners_number female owner_age  owner_experience totsale special_offer total_assets workers_num b11
generate logSale = log(totsale)
label variable logSale "Log of Total Annual Sales"
rename logSale logtotsale
rename logtotsale logtotSale
rename b11 educ
label variable logtotSale "Log of Total Annual Sales"
replace educ = 0 if educ == 1
replace educ = 4 if educ == 2
replace educ = 8 if educ == 3
replace educ = 12 if educ == 4
replace educ = 14 if educ == 5
replace educ = 16 if educ == 6
replace educ = 18 if educ == 7
replace female = 1 if female == 1
replace female = 0 if female == 2
replace female = 3 if female == 1
replace female = 1 if female == 3
label values female
label drop B2A
replace owner_experience = . if owner_experience < 0
replace owners_number = . if owners_number < 0
replace totsale = . if totsale < 0
replace total_assets = . if total_assets < 0
replace special_offer = 0 if special_offer == 2
replace special_offer = 3 if special_offer == 1
replace special_offer = 1 if special_offer == 3
label values special_offer
gen agesq = owner_age^2
gen expsq = owner_experience^2 
gen assetexp = total_assets * owner_experience 
histogram totasle
histogram logtotSale
reg totsale educ, robust
reg totsale educ owners_number owner_age owner_experience special_offer total_assets workers_num, robust
reg logtotSale educ owners_number owner_age owner_experience special_offer total_assets workers_num, robust
reg logtotSale educ owners_number owner_age owner_experience special_offer total_assets workers_num agesq expsq, robust
reg logtotSale educ owners_number owner_age owner_experience special_offer total_assets workers_num agesq expsq assetexp, robust
reg logtotSale educ owners_number owner_experience special_offer total_assets workers_num expsq assetexp
predict uhat, resid
gen uhatsq = uhat^2
reg uhatsq educ owners_number owner_experience special_offer total_assets workers_num expsq assetexp
reg logtotSale educ owners_number owner_experience special_offer total_assets workers_num expsq assetexp
predict uhat1, resid
predict yhat1, xb
gen yhat1saq = yhat1^2
gen uhat1saq = uhat1^2
reg uhat1saq yhat1  yhat1saq
regress logtotSale educ owners_number owner_age owner_experience special_offer total_assets workers_num agesq expsq assetexp
test owner_age agesq