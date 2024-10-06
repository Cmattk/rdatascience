---
title: 'data science : Transformation project'
author: "matt"
date: "2024-09-29"
output: pdf_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown
libraries in use : dplyr,nycflights13
```{r}
library(tidyverse)
library(dplyr)
library(nycflights13)
```
transformation in rows
filter() - keep rows based on values of columns
```{r}
flights |>
  filter(dep_delay > 120) # flights whose dep was 2hrs late

jan2 <- flights|>
  filter(month %in% c(3,4)) 
jan2 # dep in march and april
jan3 <- flights |> 
  filter(month == 9 | month == 12)
jan3 # dep in sep or dec
```

arrange() - changes order of rows without changing which rows are present
```{r}
flights |>
  arrange(year,month,day,dep_time)
flights |> 
  arrange(desc(dep_delay))
```
distinct() - finds rows with unique values
```{r}
dic1 <- flights|>
  distinct(origin, dest, .keep_all = TRUE) # unique origin and destination
dic1
flights |>
  count(origin, dest, sort = TRUE) # the number they occured
flights |>
  distinct(origin,dest) # unique origin and destination, without keeping the other data
```
exercise
```{r}
flights |>
  filter(arr_delay >= 120)
flights |>
  distinct(origin,dest)
flights |> 
  filter(dest == "IAH" | dest == "HOU" )
flights |> 
  filter(carrier == "B6" | carrier == "US" | carrier == "DL" )
flights |>
  filter(dep_delay >= 60 & arr_delay <= -3)
flights |>
  arrange(desc(dep_delay))
```
transformation in columns
mutate() - add new columns calculated from existing columns.
```{r}
flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .before = 1
  )

```
select() - allow zooming useful variables
starts_with("abc"): matches names that begin with “abc”.
ends_with("xyz"): matches names that end with “xyz”.
contains("ijk"): matches names that contain “ijk”.
num_range("x", 1:3): matches x1, x2 and x3.
```{r}
flights |>
  select(year,month,day)
flights |>
  select(year:day)
flights |>
  select(!year:day) #don't select
flights |>
  select(tail_num = tailnum) # rename
```
rename()
```{r}
library(janitor)
flights %>%
  clean_names()
flights %>%
  clean_names(case = "title")
```
relocate() - move variables

```{r}
flights |>
  relocate(year:dep_time, .after = time_hour)
flights |>
  relocate(starts_with("arr"), .before = dep_time)
```
exercise
```{r}
flights|>
  select(contains("dep"))
flights|>
  select(contains("dep"),contains("arr"))
flights|>
  select(dep_time,dep_delay,arr_time,arr_delay)
flights|>
  select(tail_nain = tailnum,tailNum = tailnum )
variables <- c("year", "month", "day", "dep_delay", "arr_delay")
flights|>select(all_of(variables))
flights |> select(contains("TIME"))
library(dplyr)
flights |> select(air_time_min = air_time,year,arr_delay,air_time) |> relocate(year)
flights |> 
  select(tailnum,arr_time) |>
  arrange(arr_time)

```
pipe
```{r}
flights |>
  filter(dest == "IAH") |>
  mutate(speed = distance/air_time * 60) |>
  select(year:day, dep_time,carrier,flight,speed) |>
  arrange(desc(speed))
```
group by () - divide dataset into meaningful groups.
summarise() - summary of the dataset
```{r}
flights |> group_by(month)
flights |> group_by(month) |> summarise(avg_delay = mean(dep_delay,na.rm = T), number_rows = n())
flights |> group_by(dest) |> slice_max(arr_delay, prop = 0.01) |> relocate(dest,arr_delay)
flights |> group_by(dest) |> slice_max(arr_delay, n = 1) |> relocate(dest,arr_delay)
flights |> group_by(dest) |> slice_min(arr_delay, prop = 0.01) |> relocate(dest,arr_delay)
flights |> group_by(month) |> slice_head(n = 1)
flights |> group_by(month) |> slice_tail(n = 1)
flights |> group_by(month) |> slice_sample(n=1)

```
Grouping by multiple variables
```{r}
daily <- flights |> group_by(year,month,day)
daily
daily_flights <- daily |> summarise(n = n())
daily_flights
daily_flights <- daily |> 
  summarize(
    n = n(), 
    .groups = "drop_last"
  )
```
Ungrouping

```{r}
daily2 <- daily
daily2
daily2 |> ungroup()
daily2
daily2 |> ungroup() |> 
  summarise(
    avg_delay = mean(dep_delay, na.rm = TRUE),     flights = n()
  )
```
.by
```{r}
flights |> 
  summarize(
    delay = mean(dep_delay, na.rm = TRUE), 
    n = n(),
    .by = month
  )

flights |> 
  summarize(
    delay = mean(dep_delay, na.rm = TRUE), 
    n = n(),
    .by = c(origin, dest)
  ) |> arrange(desc(delay))
```
Exercise
Which carrier has the worst average delays? Challenge: can you disentangle the effects of bad airports vs. bad carriers? Why/why not? (Hint: think about flights |> group_by(carrier, dest) |> summarize(n()))
```{r}
#This gives us the average delay per carrier, for each destination
flights |> summarise(
  avg_delay = mean(dep_delay, na.rm = T), .by = c(carrier,dest), n=n()
)
#alternative
flights %>%
  group_by(carrier, dest) %>%
  summarise(n_flights = n(),
            avg_delay = mean(dep_delay, na.rm = TRUE))
flights |> summarise(
  avg_delay = mean(dep_delay, na.rm = T), .by = c(carrier), n=n()
) |> arrange(desc(avg_delay))

model <- lm(dep_delay ~ carrier + dest, data = flights)
summary(model)

```
Why This Approach Works
Carrier Effects: By grouping flights by carrier, you account for systemic issues with the carrier’s operations (such as inefficient boarding processes, fleet maintenance, or scheduling).
Airport Effects: By also grouping by destination, you control for conditions related to specific airports (like air traffic congestion or poor weather conditions).

1. Residuals:
The residuals indicate the differences between the actual delays and the delays predicted by the model.
Most delays are within the range of -17.47 to -1.73 minutes, with some outliers (as seen by the Min and Max values, -58.73 and 1296.10).

The coefficients for each carrier show the effect of that specific carrier on departure delays relative to the reference carrier

carrierAA has a coefficient of -8.0151, meaning that, on average, American Airlines (AA) reduces the departure delay by about 8 minutes compared to the reference carrier.

carrierEV has a positive coefficient (3.2356), meaning flights with this carrier tend to have slightly longer delays.

Significant carriers: Many carriers, like carrierAA, carrierDL, and carrierMQ, have negative coefficients with highly significant p-values (e.g., p < 2e-16), indicating that they consistently reduce delays.

The coefficients for destinations measure the delay impact of flying to those specific airports relative to a reference destination.

Some airports are associated with greater delays, like destBHM (9.7329) and destCAE (15.6989), meaning flights to these destinations tend to have higher delays.
Other airports, like destAVL (-11.6488), destACK (-7.2835), and destMVY (-7.6138), are associated with fewer delays.
Destinations such as destOKC and destSAT also have significantly positive impacts on delays, with p-values < 0.05.

The R-squared value (0.01431) is very low, indicating that only 1.4% of the variance in departure delays can be explained by carrier and destination. This suggests there are many other factors influencing delays (such as weather, air traffic control, etc.).

Adjusted R-squared (0.01395) accounts for the number of predictors in the model. This value being very close to the R-squared confirms that adding more variables (carrier and destination) did not significantly improve the model's ability to explain delays.

Conclusion: Disentangling Carrier and Destination Effects

Carriers like AA, DL, and MQ consistently perform better, reducing delays compared to the baseline. Meanwhile, EV seems to have higher delays on average.
Certain destinations such as CAE, OKC, and SAT are associated with more delays, while others like AVL and ACK tend to reduce delays.
By controlling for both carrier and destination in this model, you can partially disentangle their effects. However, the low R-squared value suggests that many other variables influence flight delays, making it difficult to fully attribute delays to just these two factors.

Next Steps for Better Insights:
Adding more variables like weather, day of the week, or time of day might improve the model's ability to explain flight delays.


#Find the flights that are most delayed upon departure from each destination.
```{r}
flights |> 
  group_by(dest) |> 
  slice_max(dep_delay, n=1, na_rm = T) |> 
  relocate(dest,dep_delay)

```
#group_by(dest): Groups the data by destination.
#slice_max(dep_delay, n = 1, na_rm = TRUE): For each group (destination), it selects the row with the maximum departure delay, ignoring NA values.
#relocate(dest): Moves the dest column to the front of the data frame for better readability.


#How do delays vary over the course of the day? Illustrate your answer with a plot.
```{r}
library(tidyverse)
library(ggthemes)
```
```{r}
flights <- flights |> 
  mutate(dep_hour = floor(dep_time/100) %% 24)
avg_delay_byhour <- flights |> 
  summarise(
    avg_delay = mean(dep_delay,na.rm = T),
    .by = c(dep_hour))
ggplot(avg_delay_byhour,aes(x = dep_hour,y =
avg_delay)) + 
 geom_point(color = "red") + 
 geom_line(color = "blue") + 
 labs(title = "How do delays vary over the course of the day?",
      x="hour of day",
      y = "average delay ") + 
  theme_minimal()
```
#Insights from the Plot:
#Early morning delays (0 to 5 AM): There is a significant spike in delays during the early morning hours, peaking around 4 to 5 AM. This might be due to fewer available crews or other operational issues in the very early hours.
#Daytime stability (6 AM to around 6 PM): The delays are minimal and remain stable during regular flight hours throughout most of the day.
#Evening delays (around 9 PM and later): There’s a rise in delays again toward the late evening, possibly due to the cumulative effect of delays throughout the day or other operational bottlenecks as the day progresses.
#This pattern suggests that flights scheduled in the early morning or late evening are more likely to experience significant delays compared to midday flights.


```{r}
data <- data.frame(
  category = c('A', 'B', 'A', 'C', 'B', 'A'),
  value = c(1, 2, 3, 4, 5, 6))
count_data <- data %>%
  count(category,sort = T)
count_data
```


```{r}
df <- tibble(
  x = 1:5,
  y = c("a", "b", "a", "a", "b"),
  z = c("K", "K", "L", "L", "K")
)
df
df |> 
  group_by(y)
df |> 
  summarise(
    t = mean(x),
    .by = c(y)
  )
df |>
  group_by(y) |>
  summarize(mean_x = mean(x))
df |> 
  arrange(y)
df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x))
df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x), .groups = "drop")
df |>
  group_by(y, z) |>
  mutate(mean_x = mean(x))
```
case study
```{r}
library(Lahman)
batters <- Lahman::Batting |> 
  group_by(playerID) |> 
  summarise(
    performance = sum(H,na.rm = T)/ sum(AB, na.rm = T),
    n = sum(AB,na.rm = T)
  )
batters

#plot perfomance against n
#plot of the skill of the batter (measured by the batting average, performance) against the number of opportunities to hit the ball (measured by times at bat, n)
batters |> 
  filter(n>100) |> 
  ggplot(aes(x = n,y = performance)) +
  geom_point(alpha = 1/10,aes(color = "red")) +
  geom_smooth(se = F)
#batting average
batters |> 
  arrange(desc(performance))
```
