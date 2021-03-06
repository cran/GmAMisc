% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/refNNa.R
\name{refNNa}
\alias{refNNa}
\title{R function for refined Nearest Neighbor analysis of point patterns (G function)}
\usage{
refNNa(
  feature,
  studyplot = NULL,
  buffer = 0,
  B = 200,
  cov.var = NULL,
  order = 1
)
}
\arguments{
\item{feature}{Feature dataset (of point type).}

\item{studyplot}{Shapefile (of polygon type) representing the study area; if not provided, the
study area is internally worked out as the convex hull enclosing the input feature dataset.}

\item{buffer}{Add a buffer to the studyplot (0 by default); the unit depends upon the units of
the input data.}

\item{B}{Number of randomizations to be used (200 by default).}

\item{cov.var}{Numeric covariate (of RasterLayer class) (NULL by default).}

\item{order}{Integer indicating the kth nearest neighbour (1 by default).}
}
\description{
The function allows to perform the refined Nearest Neighbor analysis of point patterns.\cr
}
\details{
The function plots the cumulative Nearest Neighbour distance, along with an acceptance interval
(with
significance level equal to 0.05; sensu Baddeley et al., "Spatial Point Patterns. Methodology and
Applications with R", CRC Press 2016, 208) based on B (set to 200 by default) realizations of a
Complete Spatial Random process. The function also allows to control for a first-order effect
(i.e., influence of an underlaying numerical covariate) while performing the analysis. The
covariate must be of 'RasterLayer class'.\cr

The function uses a randomized approach to build the mentioned acceptance interval whereby
cumulative distributions of average NN distances of random points are computed across B
iterations. In each iteration, a set of random points (with sample size equal to the number of
points of the input feature) is drawn.\cr

Thanks are due to Dason Kurkiewicz for the help provided in writing the code to calculate the
acceptance interval.
}
\examples{
data(springs)

#produces a plot representing the cumulative nearest neighbour distance distribution;
#an acceptance interval based on 19 randomized simulations is also shown.
refNNa(springs, B=19)

#load the Startbucks datset
data(Starbucks)

#load the raster representing the numerical covariate
data(popdensity)

#perform the analysis, controlling for the 1st order effect
refNNa(Starbucks, cov.var=popdensity, B=19)

}
\seealso{
\code{\link{NNa}}
}
\keyword{refNNA}
