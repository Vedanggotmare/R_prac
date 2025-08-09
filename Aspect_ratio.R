getwd()
setwd("C:/Users/vedan/OneDrive/Desktop/R_prac")

df <- read.csv("spy500_2019.csv")
library(tidyverse)

plot(df)
glimpse(df)
df_23 <- df %>% 
  mutate(Date = as.Date(df$Date)) %>% 
  filter(Date >= as.Date("2023-01-01")) %>% 
  arrange(desc(Date))
glimpse(df_23)
plot(df_23)
df_23 %>% 
  summarise(avg_close = mean(Close,na.rm = TRUE),
            max_close = max(Close, na.rm = TRUE),
            min_close = min(Close, na.rm = TRUE))

df_23 %>% 
  ggplot(aes(x = Date, y = Close))+
  geom_line(colour = "Blue")+
  scale_x_date(date_labels = "%b %Y")+
  labs(title = "SNP500(2023+)", x = "Date", y = "Close")+
  theme_dark()

df_23$days_from_start <- as.numeric(df_23$Date - min(df_23$Date))

model <- lm(Close ~ poly(days_from_start, 10), data = df_23)
model_lin <- lm(Close ~ poly(days_from_start,1),data = df_23)

df_23$predicted <- predict(model, newdata = df_23)
df_23$predicted_lin <- predict(model_lin,newdata = df_23)

ggplot(data = df_23, aes(x = Date)) +
  geom_point(aes(y = Close), color = "blue") +  # actual data
  geom_line(aes(y = predicted), color = "red")+ # predicted curve
  geom_line(aes(y = predicted_lin),color = "green")  



#--------------------------------------------------------------------------

df_23$month <- format(df_23$Date,"%b")
df_23$month <- factor(df_23$month, levels = month.abb)

ggplot(df_23,aes(x = month, y = Close))+
  geom_boxplot(fill = "blue")+
  labs(title = "boxplot", x= "date", y = " close")
df_23 <- df_23 %>% arrange(Date)
ts_close <- ts(df_23$Close,frequency = 90)
decomp <- stl(ts_close,s.window = "period")
plot(decomp)

#---------------------------------------------------------------------------

df_23 <- df_23 %>% 
  mutate(log_returns = log(Close/lag(Close)))
df_23 <- df_23 %>% 
  mutate(abs_return = abs(log_returns))

ggplot(df_23, aes(x = Date, y = abs_return)) +
  geom_line(color = "red") +
  labs(title = "Volatility Clustering in S&P 500",
       x = "Date", y = "Absolute Log Return") +
  theme_minimal()

#---------------------------------------------------------------------------











