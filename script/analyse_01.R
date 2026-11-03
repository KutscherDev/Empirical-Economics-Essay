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
  group_by(Area, Year) %>%
  summarise(Annual_FPI = mean(Value, na.rm = TRUE), .groups = "drop") %>%
  rename(
    Country = Area,
    FPI_pct = Annual_FPI
  )

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
# 6. Datensätze zusammenführen 
# =========================================================================
all_variables <- FPI_jahr %>% 
  inner_join(Undernourishment_bereinigt, by = c("Country", "Year")) %>%
  select(-Unit) %>%
  rename(Undernourishment = Value) %>%
  inner_join(GDP_bereinigt, by = c("Country", "Year")) %>% 
  left_join(expenditure_bereinigt, by = c("Country", "Year"))


# =========================================================================
# 7. Panel-Struktur
# =========================================================================

df_lagged <- all_variables %>%
  rename(PoU = Undernourishment, FPI = FPI_pct) %>%
  group_by(Country) %>%
  # Stellt sicher, dass kein Kalenderjahr übersprungen wird:
  complete(Year = full_seq(Year, 1)) %>%
  arrange(Year, .by_group = TRUE) %>%
  mutate(
    FPI_lag1     = lag(FPI, 1),
    GDP_lag1     = lag(GDP, 1),
    gov_exp_lag1 = lag(gov_exp, 1)
  ) %>%
  ungroup()

df_final <- df_lagged %>%
  drop_na(PoU, FPI_lag1, GDP_lag1, gov_exp_lag1)

# =========================================================================
# 8. Regressionsmodelle 
# =========================================================================

model1 <- feols(PoU ~ FPI_lag1, data = df_final, vcov = ~Country)
model2 <- feols(PoU ~ FPI_lag1 + log(GDP_lag1), data = df_final, vcov = ~Country)
model3 <- feols(PoU ~ FPI_lag1 + log(GDP_lag1) + log(gov_exp_lag1), data = df_final, vcov = ~Country)

#Finale OLS inklusive fixed effects auf Länder- und Zeitebene
fe_model <- feols(PoU ~ FPI_lag1 + log(GDP_lag1) + log(gov_exp_lag1) | Country + Year, data = df_final, vcov = ~Country)

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
  vcov = ~Country, 
  output = here("output", "my_regression_table.html"),
  stars = TRUE,
  notes = "Standard errors are clustered at the country level and reported in parentheses."
)

modelsummary(
  models,
  vcov = ~Country, 
  output = "markdown",
  stars = TRUE,
  gof_map = c("nobs", "r.squared", "adj.r.squared")
)


p <- modelplot(
  models,
  coef_map = c("FPI_lag1" = "Food Price Inflation (t-1)")
) +
  
  geom_vline(xintercept = 0, linetype = "dashed", color = "firebrick", linewidth = 0.8) +
  labs(
    title = "Effect of Food Price Inflation on Undernourishment",
    subtitle = "Point estimates with 95% confidence intervals across model specifications",
    x = "Estimated Coefficient (Percentage Points)",
    y = ""
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "none",
    panel.grid.minor = element_blank()
  )

ggsave(
  filename = here("output", "model_results.png"),
  plot     = p,
  width    = 8,
  height   = 3.5,
  dpi      = 300
)


