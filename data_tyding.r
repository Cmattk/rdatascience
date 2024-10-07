---
title: "Data tidying"
author: "matt"
date: "2024-10-06"
output: pdf_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown
data source - toy dataset
tools: 
pivoting
tidyr package
tidyverse library

```{r}
library(tidyverse)
library(tidyr)
```
```{r}
table1
table2
table3
```
There are three interrelated rules that make a dataset tidy:

Each variable is a column; each column is a variable.
Each observation is a row; each row is an observation.
Each value is a cell; each cell is a single value.
```{r}
# Compute rate per 10,000
table1 |>
  mutate(rate = cases/population *10000)
#total cases per year
table1 |>
  group_by(year) |> 
  summarise(total_cases = sum(cases))
#visualize changes over time
ggplot(data = table1,aes(x = year, y = cases)) + 
  geom_point(aes(colour = country, shape = country))  + 
  geom_line(aes(group = country), color = "grey") + scale_x_continuous(breaks = c(1999,2000)) #x-axis breaks at 1999 and 2000
```


#exercise
#For each of the sample tables, describe what each observation and each column represents.
#Sketch out the process you’d use to calculate the rate for table2 and table3. You will need to perform four operations:
#Extract the number of TB cases per country per year.
#table2
```{r}
table2_clean <- table2 |>
  mutate(
    cases = ifelse(type == "cases",count,NA),
    population = ifelse(type == "population",count,NA)) |> 
  select(-type,-count)
table2_clean
```
#Extract the matching population per country per year.
```{r}
table2_final <- table2 |> 
  group_by(country,year) |> 
  summarise(
    cases = sum(ifelse(type == "cases", count, 0), na.rm = T),
    population = sum(ifelse(type == "population", count, 0),na.rm = T)
  ) |> 
  ungroup() |> 
  mutate( 
    rate = cases / population *10000
  )
table2_final
```
#Divide cases by population, and multiply by 10000.
```{r}
table2_final2 <- table2 |> 
  group_by(country,year) |> 
  summarise(
    cases = sum(ifelse(type == "cases", count, 0), na.rm = T),
    population = sum(ifelse(type == "population", count, 0),na.rm = T)
  ) |> 
  ungroup() |> 
  mutate( 
    rate = cases / population *10000
  )
table2_final2
```
Lengthening data

```{r}

```
