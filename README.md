# DEPR

## Overview

[DEPR](https://github.com/jarad/DEPR) is an R package to run WEPP using the Daily Erosion Project format

Check out [WEPPR](https://github.com/jarad/WEPPR) and [WEPPemulator](https://github.com/jarad/WEPPemulator)

## Installation

You can install the development version of DEPR from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("jarad/DEPR")
```

## Usage

### read environment file

```r
# devtools::install_github("jarad/WEPPR")
library(WEPPR)
```

```r
fpath_env <- system.file("extdata", "071000090603_2.env", package="WEPPR")
read_env(fpath_env)
```

### read run file

```r
fpath_run <- system.file("extdata", "071000090603_2.run", package="WEPPR")
read_dep_run(fpath_run)
```

### run wepp

```r
run_wepp(fpath_run)
```
