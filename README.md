
# 📊 S\&P 500 Time Series Analysis (2019–2023)

## Overview

This project is a hands-on **time series analysis** of the S\&P 500 index from 2019 onwards.
Using R and `tidyverse`, we explore:

* Data preparation & visualization
* Trend analysis with linear and polynomial regression
* Seasonal decomposition (quarterly effects)
* Volatility clustering in returns

It’s designed as both a **learning project** and a **portfolio-ready analysis**.

---

## 📂 Files

* `spy500_2019.csv` — historical S\&P 500 daily data
* `analysis.R` — main R script containing all steps
* `README.md` — documentation (you’re reading it!)

---

## 🛠️ Requirements

Install required R packages:

```r
install.packages(c("tidyverse", "lubridate"))
```

Optional for advanced time series work:

```r
install.packages(c("forecast", "tseries"))
```

---

## 🚀 Steps in the Analysis

### 1. **Setup**

```r
getwd()
setwd("C:/path/to/project")
df <- read.csv("spy500_2019.csv")
library(tidyverse)
```

### 2. **Data Exploration**

```r
plot(df)
glimpse(df)
```

* Initial inspection of trends and variable types

---

### 3. **Filtering for 2023+**

```r
df_23 <- df %>%
  mutate(Date = as.Date(Date)) %>%
  filter(Date >= as.Date("2023-01-01")) %>%
  arrange(desc(Date))
```

---

### 4. **Summary Stats**

```r
df_23 %>%
  summarise(
    avg_close = mean(Close, na.rm = TRUE),
    max_close = max(Close, na.rm = TRUE),
    min_close = min(Close, na.rm = TRUE)
  )
```

---

### 5. **Trend Visualization**

```r
ggplot(df_23, aes(x = Date, y = Close)) +
  geom_line(color = "blue") +
  labs(title = "S&P 500 Closing Prices (2023+)",
       x = "Date", y = "Closing Price") +
  theme_minimal()
```

---

### 6. **Regression Models**

#### Linear & Polynomial Regression

```r
df_23$days_from_start <- as.numeric(df_23$Date - min(df_23$Date))
model <- lm(Close ~ poly(days_from_start, 2), data = df_23)
df_23$predicted <- predict(model, newdata = df_23)
```

---

### 7. **Seasonality Analysis**

#### Using STL decomposition

```r
ts_close <- ts(df_23$Close, frequency = 90)  # Quarterly seasonality
decomp <- stl(ts_close, s.window = "periodic")
plot(decomp)
```

---

### 8. **Volatility Clustering**

#### Returns & Absolute Returns

```r
df_23 <- df_23 %>%
  arrange(Date) %>%
  mutate(log_return = log(Close / dplyr::lag(Close)),
         abs_return = abs(log_return))

ggplot(df_23, aes(x = Date, y = abs_return)) +
  geom_line(color = "red") +
  labs(title = "Volatility Clustering in S&P 500",
       x = "Date", y = "Absolute Log Return") +
  theme_minimal()
```

---

## 📚 Key Concepts Covered

* **Data wrangling** with `dplyr`
* **Visualization** with `ggplot2`
* **Polynomial regression** for trend fitting
* **STL decomposition** for seasonality
* **Volatility clustering** in financial data
* **Returns calculation** (`log` returns vs absolute returns)
* **Lag function differences** (`dplyr::lag` vs base R `lag`)

---

## 🏁 Next Steps

* Apply **GARCH models** for volatility forecasting
* Extend dataset with macroeconomic indicators
* Automate report generation with `rmarkdown`

---

Do you want me to do that?
