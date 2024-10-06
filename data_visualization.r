---
title: "data science : visualization project."
author: "matt"
date: "2024-09-21"
output:
  word_document: default
  pdf_document: default
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown

Data science projects.
libraries in use.
library(tidyverse)
library(palmerpenguins)
library(ggthemes)
```{r}
library(tidyverse)
```
```{r}
library(palmerpenguins)
```
```{r}
library(ggthemes)

```
```{r}
library(tinytex)

```
using ggplot to visualize penguins data in palmerpenguins

```{r}
#Make a scatter plot of bill_depth_mm vs. bill_length_mm. That is, make a scatter plot with bill_depth_mm on the y-axis and bill_length_mm on the x-axis. Describe the relationship between these two variables.
ggplot(data = penguins, mapping = aes(x = bill_depth_mm, y = bill_length_mm)) + geom_point(mapping = aes(colour = species, shape = species),na.rm = TRUE) + geom_smooth(method = "lm") + labs(title = "bdmm vs blmm", caption = "Data come from the palmerpenguins package.",x = "bdmm", y = "blmm", color = "species", shape = "species") + scale_color_colorblind()

#What happens if you make a scatter plot of species vs. bill_depth_mm? What might be a better choice of geom?
ggplot(data = penguins, mapping = aes(x = species, y = bill_depth_mm, colour = species)) + geom_col() + labs(title = "species vs bdmm", x = "species", y = "bdmm") + scale_color_colorblind()

#Why does the following give an error and how would you fix it?
# ggplot(data = penguins) + geom_point()
ggplot(data = penguins, mapping = aes(x= species )) + geom_bar()

#Recreate the following visualization. What aesthetic should bill_depth_mm be mapped to? And should it be mapped at the global level or at the geom level?
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g, colour = bill_depth_mm)) + geom_point(na.rm = TRUE) + geom_smooth(method = "gam")
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = island)
) +
  geom_point() +
  geom_smooth(se = FALSE)

#categorical data
ggplot(penguins,aes(x = species)) + geom_bar()
ggplot(penguins, aes(x = fct_infreq(species))) + geom_bar()

#numerical  variable
ggplot(penguins, aes(x = body_mass_g)) + geom_histogram(binwidth = 200, na.rm = T)

#Make a bar plot of species of penguins, where you assign species to the y aesthetic. How is this plot different?
ggplot(penguins, aes(x = body_mass_g)) + geom_density(na.rm = T)

#How are the following two plots different? Which aesthetic, color or fill, is more useful for changing the color of bars?
ggplot(penguins, aes(x = species)) +
  geom_bar(color = "red", na.rm = T)

ggplot(penguins, aes(x = species)) +
  geom_bar(fill = "red", na.rm = T)

#Make a histogram of the carat variable in the diamonds dataset that is available when you load the tidyverse package. Experiment with different binwidths. What binwidth reveals the most interesting patterns?
view(diamonds)
ggplot(diamonds, aes(x = carat)) + geom_histogram(binwidth = 0.5)

#relationship b2n categorical vs numerical
ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_boxplot()
ggplot(penguins, aes(x = body_mass_g, color = species, fill = species)) +
          geom_density(alpha = 0.5)

# relationship b2n 2 categorical vs numerical  
ggplot(penguins, aes(x = island, fill = species)) + geom_bar(position =  "fill")

# relationship b2n 2 numerical
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(colour = species)) + geom_smooth(method = "gam") + scale_color_colorblind()

#relationship b2n  2 or more categorical,numerical v
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(colour = species, shape = species)) + geom_smooth(method = "gam") + facet_wrap(~island)
## 
ggplot(data = mpg,mapping = aes(x = displ, y = hwy)) + 
  geom_point() +
  geom_smooth(method = "lm")

#Alt + Shift + K
my_bar_plot <- ggplot(mpg, aes(x = class)) +
  geom_bar()
my_scatter_plot <- ggplot(mpg, aes(x = cty, y = hwy)) +
  geom_point()
#saving pictures
ggsave(filename = "mpg-plot.png", plot = my_bar_plot)

```
