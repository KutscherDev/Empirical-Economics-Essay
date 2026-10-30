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

## Output

+-------------------+----------------+-----------------+-----------------+---------------+
|                   | Baseline (OLS) | Controls1 (OLS) | Controls2 (OLS) | Fixed Effects |
+===================+================+=================+=================+===============+
| (Intercept)       | 17.465***      | 94.603***       | 94.850***       |               |
+-------------------+----------------+-----------------+-----------------+---------------+
|                   | (0.985)        | (8.584)         | (8.804)         |               |
+-------------------+----------------+-----------------+-----------------+---------------+
| FPI_lag1          | 0.298**        | 0.284***        | 0.346***        | 0.064+        |
+-------------------+----------------+-----------------+-----------------+---------------+
|                   | (0.096)        | (0.083)         | (0.083)         | (0.037)       |
+-------------------+----------------+-----------------+-----------------+---------------+
| log(GDP_lag1)     |                | -11.109***      | -10.363***      | -4.498*       |
+-------------------+----------------+-----------------+-----------------+---------------+
|                   |                | (1.230)         | (1.217)         | (2.088)       |
+-------------------+----------------+-----------------+-----------------+---------------+
| log(gov_exp_lag1) |                |                 | -0.815+         | -1.589        |
+-------------------+----------------+-----------------+-----------------+---------------+
|                   |                |                 | (0.476)         | (1.181)       |
+-------------------+----------------+-----------------+-----------------+---------------+
| Num.Obs.          | 248            | 248             | 239             | 239           |
+-------------------+----------------+-----------------+-----------------+---------------+
| R2                | 0.038          | 0.278           | 0.291           | 0.955         |
+-------------------+----------------+-----------------+-----------------+---------------+
| R2 Adj.           | 0.034          | 0.272           | 0.282           | 0.946         |
+===================+================+=================+=================+===============+
| + p < 0.1, * p < 0.05, ** p < 0.01, *** p < 0.001                                      |
+===================+================+=================+=================+===============+
  

