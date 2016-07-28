
bayes = function(likelihood, prior)
{
    lp = likelihood * prior;
    evidence = sum(lp);
    return( lp/evidence );
};

# Load the data:
myData = read.csv("data.csv");
y = myData$y;

lambda = seq(0.1, 50, 0.1);
N = length(lambda);

prior = rep(1/N, times=N);

#par(mfrow=c(3,3));
plot(lambda, prior, main=0);

for (n in 1:length(y))
{
    likelihood = dpois(y[n], lambda);
    posterior = bayes(likelihood, prior);
    prior = posterior;

    plot(lambda, prior, main=n);
}

theMode = lambda[which.max(posterior)];

sorted = sort(posterior);
inHDI = cumsum(sorted) > 0.05; 

hdiThreshold = sorted[which.max(inHDI)];

hdi = sapply(posterior, function(x)
{
    if(x >= hdiThreshold)
    {
        return(x);
    }
    else
    {
        return(NA);
    }
});

points(lambda, hdi, col="red");

