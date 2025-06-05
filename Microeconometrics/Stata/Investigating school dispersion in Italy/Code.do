* Set the directory
cd "C:\Users\paose\Desktop\Progetto Inequality"

* Import and clean the dataset
import excel using "Dataset_finale.xlsx", cellrange(A1:BC21) firstrow clear
drop Imm
drop Pop_18_30_anni

* Drop these 2 regions which have huge difference from the mean of similar regions in STEM enrollment
drop if Regione == "Trentino Alto Adige"
drop if Regione == "Valle d'Aosta"

* Create the macroareas and visualize their differences
gen macroarea = ""
replace macroarea = "Nord" if inlist(Regione, "Lombardia", "Piemonte", "Veneto", "Liguria", "Trentino Alto Adige", "Friuli-Venezia Giulia", "Valle d'Aosta", "Emilia-Romagna")
replace macroarea = "Centro" if inlist(Regione, "Toscana", "Lazio", "Umbria", "Marche")
replace macroarea = "Mezzogiorno" if inlist(Regione, "Campania", "Sicilia", "Calabria", "Molise", "Puglia", "Sardegna", "Abruzzo", "Basilicata")

* Let's perform 2 different tests to check for the difference between enrollment in STEM courses in North vs Mezzogiorno (i.e. South + Islands)
graph bar Imm_STEM_su_Imm_Tot, over(macroarea, label(angle(45))) asyvars title("Rate of enrollment in STEM disciplines per macro area") ytitle("Mean rate")

encode macroarea, generate(macroarea_num)
pwmean Imm_STEM_su_Imm_Tot, over(macroarea_num) mcompare(bonferroni)

gen macroarea_NS = macroarea if macroarea != "Centro"
ttest Imm_STEM_su_Imm_Tot, by(macroarea_NS)

* Now import again the full dataset and create again the 3 areas 
import excel using "Dataset_finale.xlsx", cellrange(A1:BC21) firstrow clear
drop Imm
drop Pop_18_30_anni

gen macroarea = ""
replace macroarea = "Nord" if inlist(Regione, "Lombardia", "Piemonte", "Veneto", "Liguria", "Trentino Alto Adige", "Friuli-Venezia Giulia", "Valle d'Aosta", "Emilia-Romagna")
replace macroarea = "Centro" if inlist(Regione, "Toscana", "Lazio", "Umbria", "Marche")
replace macroarea = "Mezzogiorno" if inlist(Regione, "Campania", "Sicilia", "Calabria", "Molise", "Puglia", "Sardegna", "Abruzzo", "Basilicata")

* Check for a significant variability in the data of early school leavers, by displaying the Coefficient of Variation and the relative range
summarize Dispersione_scolastica_2022
display r(sd) / r(mean)
display (r(max) - r(min))/r(mean)

* Perform the regression at a 95% level
regress Early_leavers_2020 Gini_2020_scaled Pop_25_64_graduated_scaled_2020

* Perform also before COVID-19 crysis
regress Early_leavers_2019 Gini_2019_scaled Pop_25_64_graduated_scaled_2019