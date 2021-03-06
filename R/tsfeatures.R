#' Time Series Feature Extraction
#' 
#' The tsfeature package provides methods to extract various features from time series data
#'
#' @docType package
#' @name tsfeatures
#' @importFrom stats as.ts bw.nrd0 coef dnorm embed fitted frequency lm
#' @importFrom stats median na.contiguous na.pass residuals cor sd tsp "tsp<-" var
#' @importFrom stats quantile acf stl pchisq ar Box.test poly start
#' @importFrom purrr map map_dbl
NULL
#> NULL



#' Convert mts object to list of time series
#' @method as.list mts
#' @export
as.list.mts <- function(x)
{
  tspx <- tsp(x)
  listx <- as.list(as.data.frame(x))
  listx <- purrr::map(listx, 
            function(u){
              u <- as.ts(u)
              tsp(u) <- tspx
              return(u)
            })
  return(listx)
}