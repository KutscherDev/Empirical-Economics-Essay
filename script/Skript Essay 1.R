# =========================================================================
# 1. Pakete laden
# =========================================================================
library(tidyverse)
library(fixest)
library(modelsummary)
library(here)

# =========================================================================
# 2. FPI Daten einlesen und aufbereiten
# =========================================================================
FPI <- read_csv(here("data", "FPI.csv"))

FPI_jahr <- FPI %>%
  filter(Year != 2014) %>%
  group_by(Area, Year) %>%
  summarise(Annual_FPI = mean(Value, na.rm = TRUE), .groups = "drop") %>%
  rename(
    Country = Area,
    `FPI percentage` = Annual_FPI
  )

laender_unvollstaendig <- FPI_jahr %>%
  group_by(Country) %>%
  summarise(Anzahl_Jahre = n(), .groups = "drop") %>%
  filter(Anzahl_Jahre != 10)

FPI_bereinigt <- FPI_jahr %>%
  anti_join(laender_unvollstaendig, by = "Country")

# =========================================================================
# 3. Undernourishment Daten einlesen und aufbereiten
# =========================================================================
Undernourishment <- read_csv(here("data", "Undernourishment.csv"))

Undernourishment_bereinigt <- Undernourishment %>%
  select(
    -`Domain Code`, -Domain, -`Area Code (M49)`, -`Item Code (SDG)`, 
    -Item, -`Year Code`, -Flag, -`Flag Description`, -Note, 
    -`Element Code`, -Element
  ) %>%
  rename(Country = Area)

# =========================================================================
# 4. GDP Daten einlesen und aufbereiten
# =========================================================================
GDP <- read_csv(here("data", "GDP.csv"))

GDP_bereinigt <- GDP %>%
  rename(Country = Area, GDP = Value) %>%
  select(Country, Year, GDP)

# =========================================================================
# 5. Staatsausgaben (Expenditure) einlesen und aufbereiten
# =========================================================================

FAOSTAT_data_expenditure <- read_csv(here("data", "gov_expenditure.csv"))

expenditure_bereinigt <- FAOSTAT_data_expenditure %>%
  rename(Country = Area, gov_exp = Value) %>%
  select(Country, Year, gov_exp)

# =========================================================================
# 6. Datensätze zusammenführen & Ausreißer filtern
# =========================================================================
main_complete <- FPI_bereinigt %>% 
  inner_join(Undernourishment_bereinigt, by = c("Country", "Year")) %>%
  select(-Unit) %>%
  rename(Undernourishment = Value) %>%
  inner_join(GDP_bereinigt, by = c("Country", "Year")) %>% 
  left_join(expenditure_bereinigt, by = c("Country", "Year")) %>% 
  filter(!Country %in% c("South Sudan", "Sudan", "Haiti", "Malawi"))

# Runden der numerischen Werte
main_complete$GDP <- round(main_complete$GDP, digits = 2)
main_complete$`FPI percentage` <- round(main_complete$`FPI percentage`, digits = 2)

# =========================================================================
# 7. Panel-Struktur & Lags erstellen
# =========================================================================
main_test <- main_complete %>%
  group_by(Country) %>%
  arrange(Year, .by_group = TRUE) %>%
  mutate(
    FPI_lag1 = lag(`FPI percentage`, n = 1),
    GDP_lag1 = lag(GDP, n = 1),
    gov_exp_lag1 = lag(gov_exp, n = 1)
  ) %>%
  ungroup() %>%
  rename(
    PoU = Undernourishment,
    FPI = `FPI percentage`
  )

# =========================================================================
# 8. Regressionsmodelle 
# =========================================================================
model1 <- lm(PoU ~ FPI_lag1, data = main_test) 
model2 <- lm(PoU ~ FPI_lag1 + log(GDP_lag1), data = main_test)
model3 <- lm(PoU ~ FPI_lag1 + log(GDP_lag1) + log(gov_exp_lag1), data = main_test)

# Fixed Effects Modell (Länder- und Zeit-Fixeffekte)
fe_model <- feols(PoU ~ FPI_lag1 + log(GDP_lag1) + log(gov_exp_lag1) | Country + Year, 
                  data = main_test)

# =========================================================================
# 9. Finale HTML-Tabelle 
# =========================================================================
models <- list(
  "Baseline (OLS)"   = model1,
  "Controls1 (OLS)"  = model2,
  "Controls2 (OLS)"  = model3,
  "Fixed Effects"    = fe_model
)

modelsummary(
  models, 
  vcov = list("iid", "iid", "iid", ~Country), 
  output = "my_regression_table.html", 
  stars = TRUE,
  notes = "Standard errors are reported in parentheses. Column 4 standard errors are clustered at the country level."
)

modelsummary(
  models,
  output = "markdown",
  stars = TRUE,
  gof_map = c("nobs", "r.squared", "adj.r.squared")
)