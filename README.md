There is a pop-culture theory that there have been an unusually large number of celebrity deaths in 2016.  Malley (2016) used Wikipedia data to try to make an objective judgement about this, and found that, at least for persons linked to by at least 500 Wikipedia articles, there do indeed seem to have been more celebrity deaths in the first 121 days of 2016 than in the first 121 days of the forgoing years.

Year
Deaths of notable persons linked to by at least 500 Wikipedia pages, in the first 121 days of the year.
2010
23
2011
16
2012
12
2013
25
2014
30
2015
30
2016
34

Here we show this number (34 deaths in 2016) is statistical significant.

A suitable null hypothesis is that celebrity deaths are random, rare, and memoryless (that is to say unconnected).  This allows us to model them as a Poisson process (DeJardine 2013).

i.e. for any given number of celebrity deaths, x

P(X=x) = e-λ λx /x!

This gives us a single parameter λ for our model to estimate.

In model.r is a simple Bayesian model of this Poisson process, implemented in the R (R Core Team 2016) and JAGS (Plummer 2016) programming languages.  This uses a Markov Chain Monte Carlo (MCMC) method to derive a spread of likely values for the Poisson parameter λ.


Results can also be calculated via the grid method: in GridMethod.r we sample λ from 0.1 to 50 in intervals of 0.1, a sample size of only 500.  The simplicity of the model, the ease with which results can be checked, and the very small amount of data involved make this model an ideal learning opportunity.  Note that it doesn't take many extra parameters to put a model beyond the grid method.  See Kruschke (2012) for an excellent example of a still very simple five parameter model.  If we wanted to compare five parameters across 500 different values each the sample size would be 500^5 = 31250000000000 = 3.125*10^13.  Hence MCMC methods are usually essential in Bayesian analysis.

Now we look at the distribution of celebrity deaths implied by these values of  λ.

The cumulative probability of less than 34 deaths is 97%, thus there is less than a 5% chance in this model of the 34 deaths observed in 2016 (or more) occurring.  Thus it is traditional to reject the null hypothesis and assume there must be some underlying trend or weak connection between celebrity deaths.    Huges and Gray (2016) speculate about what the causes of this may be.

However, we should be concerned that Malley (2016) didn't find the same trend when including the deaths of notable persons with less than 500 linked Wikipedia pages.

References:

  DeJardine, Zachary Viljo Calvin (2013). Poisson Processes and Applications in Hockey. https://www.lakeheadu.ca/sites/default/files/uploads/77/docs/DejardineFinal.pdf retrieved 27th July 2016

  Hughes, Roland and Gray, Laura (2016).  Why so many celebrities have died in 2016.  http://www.bbc.co.uk/news/entertainment-arts-36108133 retrieved 27th July 2016

  Kruschke, John K (2012).  Bayesian estimation supersedes the t test

  Kruschke, John K. (2015).  Doing Bayesian data analysis: A tutorial
  with R, JAGS and Stan. Burlington, MA: Academic Press.  Elsevier.

  Malley, James O (2016). Is 2016 Really a Bizarrely Bad Year for Celebrity Deaths? Here's the Data to Prove It. http://www.gizmodo.co.uk/2016/05/is-2016-really-a-bizarrely-bad-year-for-celebrity-deaths-heres-the-data-to-prove-it/ retrieved 27th July 2016

  Plummer, Martyn (2016). rjags: Bayesian Graphical Models using MCMC. R
  package version 4-6. https://CRAN.R-project.org/package=rjags

  R Core Team (2016). R: A language and environment for statistical
  computing. R Foundation for Statistical Computing, Vienna, Austria.
  URL https://www.R-project.org/.

