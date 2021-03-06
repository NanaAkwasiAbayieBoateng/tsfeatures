% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/features.R
\name{stl_features}
\alias{stl_features}
\title{Strength of trend and seasonality of a time series}
\usage{
stl_features(x, robust = FALSE, transform = FALSE, lambda = NULL, ...)
}
\arguments{
\item{x}{a univariate time series}

\item{robust}{A logical variable indicating if robust STL should be applied.}

\item{transform}{A logical variable indicating if a Box-Cox transform should be applied
before the STL decomposition.}

\item{lambda}{The value of the Box-Cox transformation parameter if \code{transform=TRUE}.
If \code{lambda=NULL}, it is automatically selected using \code{\link[forecast]{BoxCox.lambda}}.}

\item{...}{Other arguments are passed to \code{\link[forecast]{BoxCox.lambda}}.}
}
\value{
A numeric value.
}
\description{
Computes the strength of trend and seasonality of a time series using an STL
decomposition (or for non-seasonal time series, a penalized regression spline smoother).
}
