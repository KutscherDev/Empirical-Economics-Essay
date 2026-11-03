# Food Price Shocks and Malnutrition Rates in Developing Countries 

An empirical panel data analysis examining the transmission of price shocks to malnutrition indicators across developing economies using FAOSTAT data.

Formally, this analysis tests the hypothesis that **H₁: β₁ > 0** — that is, an increase in food price inflation is expected to raise the prevalence of undernourishment by eroding the real exchange entitlements of vulnerable households, net of national income and state capacity.

## Variables & Proxies

* **Dependent Variable:** Prevalence of undernourishment (PoU, % of population) | Continuous percentage (0–100)
* **Main Regressor:** Food Price Inflation (FPI, annual % change), lagged by 1 year
* **Control Variables:** GDP per capita (constant USD) and Government Expenditure | Log levels

To empirically test this framework, this analysis utilizes panel data from 31 developing countries, observed over the span from 2015 to 2024, provided by the Food and Agriculture Organization of the UN. 

## Econometric Methodology

The baseline specification relies on a two-way fixed effects (TWFE) panel model:

> **PoU<sub>it</sub> = α<sub>i</sub> + λ<sub>t</sub> + β₁·FPI<sub>i, t-1</sub> + β₂·log(GDP<sub>i, t-1</sub>) + β₃·log(gov_exp<sub>i, t-1</sub>) + ε<sub>it</sub>**

Controlling for:
* **Country fixed effects (α<sub>i</sub>):** time-constant unobserved heterogeneity
* **Year fixed effects (λ<sub>t</sub>):** time-variant trends like global macroeconomic shocks 

Standard errors are clustered at the country level to account for serial correlation.

## Output

| Variable | Baseline (OLS) | Controls 1 (OLS) | Controls 2 (OLS) | Fixed Effects (TWFE) |
| :--- | :---: | :---: | :---: | :---: |
| **(Intercept)** | 17.159***<br>(2.192) | 81.339***<br>(21.230) | 88.225***<br>(22.619) | |
| **FPI_lag1** | 0.309+<br>(0.161) | 0.298+<br>(0.169) | 0.340+<br>(0.177) | 0.054<br>(0.061) |
| **log(GDP_lag1)** | | -9.250**<br>(2.953) | -8.862**<br>(2.949) | -2.246<br>(3.729) |
| **log(gov_exp_lag1)** | | | -1.276<br>(1.196) | -1.748<br>(1.226) |
| **Country FE** | No | No | No | **Yes** |
| **Year FE** | No | No | No | **Yes** |
| **Num. Obs.** | 265 | 265 | 265 | 265 |
| **R²** | 0.053 | 0.212 | 0.231 | 0.957 |
| **R² Adj.** | 0.050 | 0.206 | 0.223 | 0.949 |

*Significance levels:* `+ p < 0.1, * p < 0.05, ** p < 0.01, *** p < 0.001`. *Standard errors in parentheses.*

## Summary

* **Pooled OLS:** Food price inflation exhibits a positive, marginally significant association with Undernourishment (β ≈ 0.31–0.34 at 10% level). This relationship remains stable after controlling for lagged GDP and government expenditure.
* **Two-Way Fixed Effects (TWFE):** Adding country and year fixed effects causes the coefficient to collapse to 0.054, losing all statistical significance. Controls also become insignificant.
* **Empirical Conclusion:** After purging time-invariant country baselines and common global macro shocks, this analysis shows no statistically detectable within-country relationship between one-year lagged food price inflation and malnutrition rates.

## Potential Limits

* **Restrictive Lag Horizon:** Lagging by only one year assumes inflation has zero impact beyond 12 months. It might be insufficient to measure real-world behavior in food consumption and does not capture previous inflation shocks (lags ≥ 2 years) or coping mechanisms like household asset depletion.
* **Dynamics & Autocorrelation:** Malnutrition is a persistent, chronic stock variable. The specification excludes the dynamic persistence of malnutrition and the autocorrelation of inflation series.
* **Time-Varying Country Shocks:** While TWFE absorbs static country traits and uniform year shocks, it cannot control for idiosyncratic shocks that vary across both country and time (e.g., local extreme weather, regional civil conflict, or local currency crises).
