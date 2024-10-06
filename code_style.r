---
title: 'Workflow: code style pj'
author: "matt"
date: "2024-10-02"
output: pdf_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown

```{r}
library(styler)
library(tidyverse)
library(nycflights13)
```
names
```{r}
#names
short_flights <- flights |> filter(air_time < 60)
#spaces
a = 5
b = 7
d = 8
z <- (a + b)^2 / d
x = 5:79
mean(x, na.rm = TRUE)
flights |> 
  mutate(
    speed      = distance / air_time,
    dep_hour   = dep_time %/% 100,
    dep_minute = dep_time %%  100
  )
#pipe
flights |>  
  filter(!is.na(arr_delay), !is.na(tailnum)) |> 
  count(dest)
#ggplot2
flights |> 
  group_by(month) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE)
  ) |> 
  ggplot(aes(x = month, y = delay)) +
  geom_point() + 
  geom_line()
flights |> 
  group_by(dest) |> 
  summarize(
    distance = mean(distance),
    speed = mean(distance / air_time, na.rm = TRUE)
  ) |> 
  ggplot(aes(x = distance, y = speed)) +
  geom_smooth(
    method = "loess",
    span = 0.5,
    se = FALSE, 
    color = "white", 
    linewidth = 4
  ) +
  geom_point()
#exercise
flights|>filter(dest=="IAH")|>group_by(year,month,day)|>summarize(n=n(),
delay=mean(arr_delay,na.rm=TRUE))|>filter(n>10)

flights |> 
  filter(
    carrier == "UA",
    dest %in% c("IAH","HOU"),
    sched_dep_time > 0900,
    sched_arr_time < 2000
    ) |> 
  group_by(flight) |>
  summarize(
    delay = mean(arr_delay,na.rm=TRUE),
    cancelled = sum(is.na(arr_delay)),
    n=n()
    ) |> 
  filter(n>10)
```
