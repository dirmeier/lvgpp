# gpR: Gaussian processes in R
#
# Copyright (C) 2015 - 2016 Simon Dirmeier
#
# This file is part of gpR.
#
# gpR is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# gpR is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with gpR. If not, see <http://www.gnu.org/licenses/>.

#' @title Covariance function
#'
#' @description Calculates the covariance/kernel of a set of input points
#'
#' @export
#' @param x1  a vector of random real numbers
#' @param x2  a vector of random real numbers
#' @param pars  a list containing hyperparameters and kernel specification
#' @return the calculated kernel/covariance matrix of size (\code{length(x1)} x \code{length(x2)})
#' @examples
#'  x <- rnorm(100)
#'  pars <- list(var=1, inv.scale=2, gamma=2, noise=.1, kernel="gamma.exp")
#'  K <- covariance.function(x, x, pars)
covariance.function <- function(x1, x2, pars=NULL)
{
  if (is.null(pars))
    pars <- list(var=1, inv.scale=2, gamma=2, noise=.1, kernel="gamma.exp")
  fun <-  switch(pars$kernel, gamma.exp = .gamma.exp, NULL)
  if (is.null(fun))
    stop("Wrong kernel provided! Pls check method documentation for details.")
  K <- matrix(outer(x1, x2, FUN = function(x, y) fun(x, y, pars)),
              length(x1), length(x2))
  if (length(pars) == 5 && length(x1) == length(x2))
    K <- K + pars$noise * diag(length(x1))
  invisible(K)
}

#' @title Gamma-exponential kernel function
#'
#' @noRd
#' @examples
#' .gamma.exp(1:5, 1:5, pars=list(inv.scale=1, gamma=1))
.gamma.exp <-
function(x1, x2, pars)
{
  d <- x1 - x2
  pars$var * exp(- (1/(pars$inv.scale)) * (d**pars$gamma))
}
