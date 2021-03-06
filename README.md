
<!-- README.md is generated from README.Rmd. Please edit that file -->
tsfeatures
==========

[![Pending Pull-Requests](http://githubbadges.herokuapp.com/robjhyndman/tsfeatures/pulls.svg?style=flat)](https://github.com/robjhyndman/tsfeatures/pulls)

The R package *tsfeatures* provides methods for extracting various features from time series data.

Installation
------------

The **stable** version on R CRAN is coming soon.

You can install the **development** version from [Github](https://github.com/robjhyndman/tsfeatures) with:

``` r
# install.packages("devtools")
devtools::install_github("robjhyndman/tsfeatures")
```

Usage
-----

### Hyndman, Wang and Laptev (ICDM 2015)

``` r
library(tsfeatures)
library(tidyverse)
library(anomalous)

# Compute the features used in Hyndman, Wang & Laptev (ICDM 2015).
# Note that crossing_points is defined slightly differently in the tsfeatures
# package than in the Hyndman et al (2015) paper. Other features are the same.
# Using the real data from the paper
yahoo <- cbind(dat0, dat1, dat2, dat3)
hwl <- bind_cols(
         tsfeatures(yahoo,
           c("acf1","stl_features","entropy","lumpiness",
             "flat_spots","crossing_points")),
         tsfeatures(yahoo, "max_kl_shift", width=48),
         tsfeatures(yahoo,
           c("mean","var"), scale=FALSE, na.rm=TRUE),
         tsfeatures(yahoo,
           c("max_level_shift","max_var_shift"), trim=TRUE)) %>%
  select(mean, var, acf1, trend, linearity, curvature, season, peak, trough,
         entropy, lumpiness, spike, max_level_shift, max_var_shift, flat_spots,
         crossing_points, max_kl_shift, time_kl_shift)
```

``` r
# 2-d Feature space
prcomp(na.omit(hwl), scale=TRUE)$x %>% 
  as_tibble() %>%
  ggplot(aes(x=PC1, y=PC2)) +
    geom_point()
```

![](READMEfigs/yahoo2-1.png)

### Kang, Hyndman & Smith-Miles (IJF 2017)

``` r
library(tsfeatures)
library(tidyverse)
library(forecast)

M3data <- purrr::map(Mcomp::M3, 
  function(x){
      tspx <- tsp(x$x)
      ts(c(x$x,x$xx), start=tspx[1], frequency=tspx[3])
  })
khs <- bind_cols(
  tsfeatures(M3data, c("frequency", "entropy")),
  tsfeatures(M3data, "stl_features", scale=FALSE, transform=TRUE, lower=0, upper=1, method='loglik'),
  tsfeatures(M3data, "BoxCox.lambda", scale=FALSE, lower=0, upper=1, method="loglik")) %>% 
  select(frequency, entropy, trend, season, acfremainder, BoxCox.lambda) %>%
  replace_na(list(season=0)) %>%
  rename(
    Period = frequency,
    Entropy = entropy,
    Trend = trend,
    Season = season,
    ACF1 = acfremainder,
    Lambda = BoxCox.lambda)
```

``` r
# Fig 1 of paper
GGally::ggpairs(khs)
```

![](READMEfigs/ijf2017graphs-1.png)

``` r

# 2-d Feature space (Top of Fig 2)
prcomp(khs, scale=TRUE)$x %>%
  as_tibble() %>%
  bind_cols(Period=as.factor(khs$Period)) %>%
  ggplot(aes(x=PC1, y=PC2)) +
    geom_point(aes(col=Period))
```

![](READMEfigs/ijf2017graphs-2.png)

### Kang, Hyndman & Li (in preparation)

``` r
# Compute all features in MARs paper

library(tsfeatures)
library(tidyverse)
library(forecast)

M3data <- purrr::map(Mcomp::M3, function(x)x$x)

nsdiffs <- function(x){
  c(nsdiffs=ifelse(frequency(x)==1L, 1L, forecast::nsdiffs(x)))
}
features1 <- c(
  "entropy",
  "stl_features",
  "acf1",
  "max_kl_shift",
  "lumpiness",
  "ndiffs",
  "nonlinearity",
  "frequency",
  "nsdiffs",
  "heterogeneity"
)
features2 <- c(  
  "max_level_shift",
  "max_var_shift"
)

yk <- bind_cols(
        tsfeatures(M3data, features1),
        tsfeatures(M3data, features2, trim=TRUE)) %>% 
  select(entropy, trend, linearity, curvature, acf1,
    acfremainder, max_kl_shift, max_level_shift, max_var_shift, 
    ndiffs, Nonlinearity, frequency, season, nsdiffs,
    ARCHtest.p, GARCHtest.p, Boxtest.p, GARCHBoxtest.p, Hetero)
# What happened to var change on remainder?
```

License
-------

This package is free and open source software, licensed under GPL-3.
