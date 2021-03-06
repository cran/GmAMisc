% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/distCovarModel.R
\name{distCovarModel}
\alias{distCovarModel}
\title{R function to model (and test) the dependence of a point pattern on the distance to another
pattern}
\usage{
distCovarModel(
  feature,
  cov.var,
  studyplot = NULL,
  buffer = 0,
  Foxall = FALSE,
  oneplot = FALSE
)
}
\arguments{
\item{feature}{Feature (of point type; SpatialPointsDataFrame class) representing the spatial
point pattern of interest.}

\item{cov.var}{Feature (of either point or line type; SpatialPointsDataFrame or
SpatialLinesDataFrame class) the distance to which represents the spatial covariate.}

\item{studyplot}{Feature (of polygon type; SpatialPolygonsDataFrame) representing the study
area; if not provided, the study area is internally worked out as the bounding polygon based on
the union the convex hulls of the feature and of the cov.var data.}

\item{buffer}{Add a buffer to the convex hull of the study area (0 by default); the unit depends
upon the units of the input data.}

\item{Foxall}{Set to TRUE, will plot the Foxall's J function.}

\item{oneplot}{Set to TRUE (default), will plot the charts into a single visualization.}
}
\value{
The function returns a list storing the following components \itemize{
 \item{$H0-model: }{info and relevant statistics regarding the Null Model}
 \item{$H1-model: }{info and relevant statistics regarding the Alternative Model}
 \item{$Model comparison (LRT) }{results of the Likelihood Ratio test}
 \item{$AIC-H0: }{AIC of the Null Model}
 \item{$AIC-H1: }{AIC of the Alternative Model}
 \item{$KS test: }{information regarding the cumulative distribution comparison via
Kolmogorov-Smirnov test}
 \item{$AUC: }{the AUC statistics}
}
}
\description{
The function is a wrapper for a number of functions out of the extremely useful 'spatstat'
package (specifically, ppm(), cdf.test(), auc(), roc(), effectfun()). It allows to test if there
is a significant dependence of the input point pattern on a spatial covariate (first-order
effect), the latter being the distance to another feature (of either point or line type).\cr The
function takes as input two datasets: a point patter (SpatialPointsDataFrame class) and a feature
(either SpatialPointsDataFrame or SpatialLinesDataFrame class) the distance to which is used as
spatial covariate for the input point pattern.\cr
}
\details{
The function fits a inhomogeneous Poisson point process (Alternative Model-H1) with the distance
to the second feature entered by the user ('cov.var' parameter) used as spatial covariate. In
other words, the fitted alternative model is a Poisson point process with intensity of the point
pattern as a loglinear function of the distance to the second pattern entered by the user (see
Baddeley et al., "Spatial Point Patterns. Methodology and Applications with R", CRC Press 2016,
309-313). The distance to the second feature is internally calculated via the spatstat's
'distfun()' function.

Also, the function fits a homogeneous Poisson point model (Null Model-H0, equivalent to Complete
Spatial Randomness: Baddeley et al., "Spatial Point Patterns. Methodology and Applications with
R", CRC Press 2016, 305-306), that is used as comparison for the inhomogeneous point process
model in a Likelihood Ratio test (Baddeley et al., "Spatial Point Patterns. Methodology and
Applications with R", CRC Press 2016, 334-335). A significant result, i.e. a low p-value,
suggests rejecting the Null Hypothesis of CSR in favour of the Alternative Hypothesis of a
Poisson point process affected by a covariate effect (i.e., inhomogeneous intensity due to the
influence of the covariate) (Baddeley et al., "Spatial Point Patterns. Methodology and
Applications with R", CRC Press 2016, 305). \cr

The function returns a 4 plots, which can be arranged in just one visualization setting the
parameter oneplot to TRUE:\cr

-plot of the study area along with the point pattern of interest and the second feature entered
by the user (whose distance is the spatial covariate);\cr

-plot of the fitted intensity against the spatial covariate (Baddeley et al., "Spatial Point
Patterns. Methodology and Applications with R", CRC Press 2016, 308);\cr

-plot of the cumulative distribution of the covariate at the data points against the cumulative
distribution of the covariate at all the spatial location within the study area (rationale:
Baddeley et al., "Spatial Point Patterns. Methodology and Applications with R", CRC Press 2016,
184-185);\cr

-plot of the ROC curve, which help assessing the strength of the dependence on the covariate
(Baddeley et al., "Spatial Point Patterns. Methodology and Applications with R", CRC Press 2016,
187-188).\cr

Setting the parameter Foxall to TRUE, the third plot will be replaced by the chart of the
Foxall's J function, which is another "useful statistic" when the covariate is the distance to a
spatial pattern (Baddeley et al., "Spatial Point Patterns. Methodology and Applications with R",
CRC Press 2016, 187, 282-284). Values of J are uqual to 1 when the two patterns are independent
random patterns; values <1 indicate that the input point pattern tends to be closer to the
cov.var pattern than expected for random points; values >1 indicate that the input point pattern
avoid the cov.var pattern, i.e. the point pattern is more likely than random points to lie far
away from the cov.var pattern (see Baddeley et al., "Spatial Point Patterns. Methodology and
Applications with R", CRC Press 2016, 284).
}
\examples{

#load a point dataset representing some locations
data(locations)

#load a point dataset representing some locations, the distance to which
#is used as spatial covariate
data(springs)

#perform the analysis, and store the results in the 'results' object
results <- distCovarModel(locations, springs)

}
\seealso{
\code{\link{distRandSign}} , \code{\link{Aindex}} , \code{\link{pointsCovarModel}} ,
 \code{\link[spatstat.core]{auc}} , \code{\link[spatstat.core]{cdf.test}} ,
 \code{\link[spatstat.core]{effectfun}} , \code{\link[spatstat.core]{ppm}} , \code{\link[spatstat.core]{roc}}
}
\keyword{distCovarModel}
