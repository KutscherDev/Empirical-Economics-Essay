# Food Price Shocks and Malnutrition Rates in Developing Countries 

An empirical panel data analysis examining the transmission of price shocks to malnutrition indicators across developing economies using FAOSTAT data.

Undernourishment remains a critical global policy challenge, necessitating a deep understanding of how macroeconomic shocks impact food security.

Formally, this analysis tests the hypothesis that H1: β₁ > 0 — that is, an increase in food price inflation is expected to raise the prevalence of undernourishment by eroding the real exchange entitlements of vulnerable households, net of national income and state capacity.

## Variables & Proxies

Dependent Variable: Prevalence of undernourishment (% of population)  | Continuous percentage / log-transformed |
Main Regressor: Food Price Index (FPI) 
Control Variables: GDP per capita (USD) | Log levels, ratios 

To empirically test this framework, this analysis utilizes panel data from 31 developing countries, observed over the span from 2015 to 2024, provided by the Food and Agriculture Organization of the UN. 
The Prevalence of Undernourishment (PoU) is employed as the primary proxy for national hunger levels. 
The core independent variable of interest is Food Price Inflation (FPI). By isolating food-specific inflation rather than general consumer inflation, the model targets the exact price shocks that most directly threaten the food entitlements of vulnerable demographics.

Time-invariant institutional characteristics, such as geographic climate stability, deep-rooted agricultural infrastructure, and structural safety nets, heavily influence both inflation levels and baseline hunger. To mitigate this, per capita Gross Domestic Product (GDP) and Government Expenditure (gov_exp) are introduced as control variables, acting as proxies for baseline economic development and state intervention capacity, respectively. 

## Econometric Methodology

The baseline specification relies on a two-way fixed effects (TWFE) panel model:
Controlling for...
  country fixed effects, i.e. time-constant unobserved heterogeneity
  year fixed effects, i.e. time-variant trends like macroeconomic shocks 
Standard errors are clustered at the country level to account for serial correlation.
  

