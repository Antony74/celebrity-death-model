
source("DBDA2E-utilities.R");
require(rjags);

fileNameRoot="model" # For output file names.

# Load the data:
myData = read.csv("data.csv");
y = myData$y;
Ntotal = length(y);

dataList = list(
	y = y,
	Ntotal = Ntotal,
	mean = mean(y),
	sd = sd(y)); 

# Define the model:
modelString = "
	model
	{
		for (i in 1:Ntotal)
		{
			y[i] ~ dpois( lambda );
		}

		# Multiplying the standard deviation by 1000 gives us a suitably vague prior distribution.
		# We then take the inverse square to convert the standard deviation into precision.
		lambda ~ dnorm(mean, 1/(sd*1000)^2);

		## Our model isn't particularly sensitive to the chosen prior distribution.
		## For instance, this uniform prior gives almost the same results
#		lambda ~ dunif(1, 100);
	}
";

writeLines(modelString, con="TEMPmodel.txt");

# Run the chains:
jagsModel = jags.model(
					file="TEMPmodel.txt",
					data=dataList,
                    n.chains=3,
					n.adapt=500);

update(jagsModel, n.iter=500);

codaSamples = coda.samples(
				jagsModel,
				variable.names=c("lambda"),
                n.iter=3334);

save(codaSamples, file="Mcmc.Rdata");

#
# Convergence diagnostics:
#
diagMCMC( codaObject=codaSamples , parName="lambda" );

#
# Posterior descriptives:
#
default.par = par(no.readonly = TRUE);
openGraph(height=3,width=4);
par(mar=c(3.5,0.5,2.5,0.5), mgp=c(2.25,0.7,0) );

plotPost(
	codaSamples[,"lambda"],
	main="lambda",
	xlab=bquote(lambda), 
    cenTend="median",
	credMass=0.95 );

#
# Posterior predictive distribution
#

arrSamples = as.array(codaSamples);

x = 0:50;
arrP = sapply(x, function(nDeaths)
{
	return(mean(dpois(nDeaths, arrSamples)));
});

arrCum = cumsum(arrP);

par(default.par);
plot(x, y=arrCum, xlab="Deaths", ylab="Cumlative probability");

cat("P(deaths < 34) = ", arrCum[34], "\n");

