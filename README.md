
<!-- README.md is generated from README.Rmd. Please edit that file -->

# airparis

<!-- badges: start -->

<!-- badges: end -->

Package `airparis`

## Installation

You can install the released version of airparis from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("airparis")
```

## Example

``` r
library(airparis)
```

### ATMO index

``` r
data_atmo <- read_atmo()
score <- as.list(data_atmo$score)
names(score) <- format(data_atmo$date, "%Y-%m-%d")
names(score) <- as.character(as.integer(data_atmo$date))
# jsonlite::toJSON(score, auto_unbox = TRUE )
```
