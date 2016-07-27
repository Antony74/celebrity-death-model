
source("DBDA2E-utilities.R");
require(rjags);

fileNameRoot="model" # For output file names.

# Load the data:
myData = read.csv("data.csv");
y = myData$y;
Ntotal = length(y);

dataList = list(y = y, Ntotal = Ntotal); 

# Define the model:
modelString = "
model {
  for ( i in 1:Ntotal ) {
    y[i] ~ dpois( lambda )
  }
  lambda ~ dunif( 1 , 1000 )
}
";

writeLines(modelString, con="TEMPmodel.txt");

# Run the chains:
jagsModel = jags.model(
					file="TEMPmodel.txt",
					data=dataList,
                    n.chains=3,
					n.adapt=500);

update(jagsModel , n.iter=500);

codaSamples = coda.samples(
				jagsModel,
				variable.names=c("lambda"),
                n.iter=3334);

save(codaSamples, file="Mcmc.Rdata");

# Examine the chains:
# Convergence diagnostics:
diagMCMC( codaObject=codaSamples , parName="lambda" );

# Posterior descriptives:
openGraph(height=3,width=4)
par( mar=c(3.5,0.5,2.5,0.5) , mgp=c(2.25,0.7,0) )
plotPost( codaSamples[,"lambda"] , main="lambda" , xlab=bquote(lambda) )

# Re-plot with different annotations:
plotPost( codaSamples[,"lambda"] , main="lambda" , xlab=bquote(lambda) , 
          cenTend="median" ,  credMass=0.95 );


