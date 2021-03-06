#' R function for plotting univariate classification using Jenks' natural break method
#'
#' The function  allows to break a dataset down into a user-defined number of breaks and to nicely
#' plot the results, adding a number of other relevant information. Implementing the Jenks' natural
#' breaks method, it allows to find the best arrangement of values into different classes.\cr
#'
#' The function produces a chart in which the values of the input variable are arranged on the
#' x-axis in ascending order, while the index of the individual observations is reported on the
#' y-axis. Vertical dotted red lines correspond to the optimal break-points which best divide the
#' input variable into the selected classes. The break-points (and their values) are reported in the
#' upper part of the chart, onto the corresponding break lines. Also, the chart's subtitle reports
#' the Goodness of Fit value relative to the selected partition, and the partition which correspond
#' to the maximum GoF value.
#'
#' @param data Vector storing the data.
#' @param n Number of  classes in which the dataset must be broken down (3 by default).
#' @param brks.cex Adjusts the size of the labels used in the returned plot to display the classes'
#'   break-points.
#' @param top.margin Adjusts the distance of the labels from the top margin of the returned chart.
#' @param dist Adjusts the distance of the labels from the dot used to display the data points.
#'
#' @return  The function returns a list containing the following components: \itemize{
##'  \item{$info: }{information about whether or not the method created non-unique breaks}
##'  \item{$classif: }{created classes and number of observations falling in each class}
##'  \item{$classif$brks: }{classes' break-points}
##'  \item{$breaks$max.GoF: }{number of classes at which the maximum GoF is achieved}
##'  \item{$class.data: }{dataframe storing the values and the class in which each value actually
##'  falls into}
##' }
#'
#' @keywords plotJenks
#'
#' @export
#'
#' @importFrom classInt classIntervals jenks.tests
#'
#' @examples
#' #create a toy dataset
#' mydata <- rnorm(100, 30, 10)
#'
#' # performs the analysis, using 6 as number of desired classes,
#' # and store the results in the 'res' object
#' res <- plotJenks(mydata, n=6)
#'
plotJenks <- function(data, n=3, brks.cex=0.70, top.margin=10, dist=5){
  df <- data.frame(sorted.values=sort(data, decreasing=TRUE))
  Jclassif <- classIntervals(df$sorted.values, n, style = "jenks") #requires the 'classInt' package
  test <- classInt::jenks.tests(Jclassif) #requires the 'classInt' package
  df$class <- base::cut(df$sorted.values, base::unique(Jclassif$brks), labels=FALSE, include.lowest=TRUE) #the function unique() is used to remove non-unique breaks, should the latter be produced. This is done because the cut() function cannot break the values into classes if non-unique breaks are provided
  if(length(Jclassif$brks)!=length(base::unique(Jclassif$brks))){
    info <- ("The method has produced non-unique breaks, which have been removed. Please, check '...$classif$brks'")
  } else {info <- ("The method did not produce non-unique breaks.")}
  loop.res <- numeric(nrow(df))
  i <- 1
  repeat{
    i <- i+1
    loop.class <- classInt::classIntervals(df$sorted.values, i, style = "jenks")
    loop.test <- classInt::jenks.tests(loop.class)
    loop.res[i] <- loop.test[[2]]
    if(loop.res[i]>0.9999){
      break
    }
  }
  max.GoF.brks <- which.max(loop.res)
  graphics::plot(x=df$sorted.values, y=c(1:nrow(df)), type="b", main=paste0("Jenks natural breaks optimization; number of classes: ", n), sub=paste0("Goodness of Fit: ", round(test[[2]],4), ". Max GoF (", round(max(loop.res),4), ") with classes:", max.GoF.brks), ylim =c(0, nrow(df)+top.margin), cex=0.75, cex.main=0.95, cex.sub=0.7, ylab="observation index", xlab="value (increasing order)")
  abline(v=Jclassif$brks, lty=3, col="red")
  graphics::text(x=Jclassif$brks, y= max(nrow(df)) + dist, labels=sort(round(Jclassif$brks, 2)), cex=brks.cex, srt=90)
  results <- list("info"=info, "classif" = Jclassif, "breaks.max.GoF"=max.GoF.brks, "class.data" = df)
  return(results)
}
