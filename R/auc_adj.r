#' R function for optimism-adjusted AUC (internal validation)
#'
#' The function allows to calculate the AUC of a (binary) Logistic Regression model, adjusted for
#' optimism.\cr
#'
#' The function performs an internal validation of a model via a bootstrap procedure (devised by
#' Harrell and colleagues), which enables to estimate the degree of optimism of a fitted model and
#' the extent to which the model will be able to generalize outside the training dataset. If you
#' want more info, you can refer to this website
#' (http://thestatsgeek.com/2014/10/04/adjusting-for-optimismoverfitting-in-measures-of-predictive-ability-using-bootstrapping/),
#' and/or read the following interesting article (in which the bootstrap procedure is described at
#' page 776):
#' http://thestatsgeek.com/2014/10/04/adjusting-for-optimismoverfitting-in-measures-of-predictive-ability-using-bootstrapping/\cr
#'
#' @param data Dataframe containing the dataset (note: the Dependent Variable must be stored in the
#'   first column to the left).
#' @param fit Object returned from glm() function.
#' @param B Desired number of bootstrap resamples (suggested values: 100 or 200; the latter is used by default).
#'
#' @return The returned boxplots represent:\cr -the distribution of the AUC value in the bootstrap
#'   sample (auc.boot), which represents "an estimation of the apparent performance" (according to
#'   the aforementioned reference);\cr -the distribution of the AUC value deriving from the model
#'   fitted to the bootstrap samples and evaluated on the original sample (auc.orig), which
#'   represents the model performance on independent data.\cr At the bottom of the chart, the
#'   apparent AUC (i.e., the value deriving from the model fitted to the original dataset) and the
#'   AUC adjusted for optimism are reported.
#'
#' @keywords aucadj
#'
#' @export
#'
#' @importFrom pROC ci.auc
#' @importFrom kimisc sample.rows
#' @importFrom graphics boxplot
#' @importFrom stats fitted glm predict.glm
#' @importFrom graphics title
#'
#' @examples
#' # load the sample dataset
#' data(log_regr_data)
#'
#' # fit a logistic regression model, storing the results into an object called 'model'
#' model <- glm(admit ~ gre + gpa + rank, data = log_regr_data, family = "binomial")
#'
#' aucadj(data=log_regr_data, fit=model, B=200)
#'
#' @seealso \code{\link{logregr}} , \code{\link{modelvalid}}
#'
aucadj <- function(data, fit, B=200){

  fit.model <- fit

  data$pred.prob <- fitted(fit.model)

  auc.app <- pROC::roc(data[,1], data$pred.prob, data=data, quiet=TRUE)$auc             # require 'pROC'

  auc.boot <- vector (mode = "numeric", length = B)
  auc.orig <- vector (mode = "numeric", length = B)
  o <- vector (mode = "numeric", length = B)

  pb <- txtProgressBar(min = 0, max = B, style = 3)                                    #set the progress bar to be used inside the loop

  for(i in 1:B){
    boot.sample <- kimisc::sample.rows(data, nrow(data), replace=TRUE)                # require 'kimisc'

    fit.boot <- glm(formula(fit.model), data = boot.sample, family = "binomial")

    boot.sample$pred.prob <- fitted(fit.boot)

    auc.boot[i] <- pROC::roc(boot.sample[,1], boot.sample$pred.prob, data=boot.sample, quiet=TRUE)$auc

    data$pred.prob.back <- predict.glm(fit.boot, newdata=data, type="response")

    auc.orig[i] <- pROC::roc(data[,1], data$pred.prob.back, data=data, quiet=TRUE)$auc

    o[i] <- auc.boot[i] - auc.orig[i]

    setTxtProgressBar(pb, i)
  }

  auc.adj <- auc.app - (sum(o)/B)

  graphics::boxplot(auc.boot, auc.orig, names=c("auc.boot", "auc.orig"))

  title(main=paste("Optimism-adjusted AUC", "\nn of bootstrap resamples:", B),
        sub=paste("auc.app (blue line)=", round(auc.app, digits=4),"\nadj.auc (red line)=", round(auc.adj, digits=4)),
        cex.main=0.85, cex.sub=0.8)

  abline(h=auc.app, col="blue", lty=2)

  abline(h=auc.adj, col="red", lty=3)
}
