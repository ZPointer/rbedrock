% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rbedrock.R
\name{parse_chunk_keys}
\alias{parse_chunk_keys}
\title{Extract information from chunk keys.}
\usage{
parse_chunk_keys(keys)
}
\arguments{
\item{keys}{A character vector of database keys.}
}
\value{
A tibble containing information extracted from chunk keys. Keys that do not contain chunk data are dropped.
}
\description{
Extract information from chunk keys.
}
\examples{
parse_chunk_keys("@0:0:0:47-1")
}
