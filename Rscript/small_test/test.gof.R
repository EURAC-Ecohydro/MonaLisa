#
#
# Author: Emanuele Cordano
#
# Test: tast simulation settings for GOF 


#

rm(list=ls())
library(geotopOptim2)
#source('/home/ecor/Dropbox/R-packages/geotopOptim2/R/geotop.execution.R')
#source('/home/ecor/Dropbox/R-packages/geotopOptim2/R/geotop.gof.2.R') 

#wpath <-  '/home/ecor/local-projects/MonaLisa/run/DOMEF_1500_Optim_005' 

wpath <- "/home/gbertoldi/Simulations/NEPAS_2000_001"

##wpath <- system.file('geotop-simulation/B2site',package="geotopOptim2")
bin <-   "geotop_se27xx"
runpath <- "/home/gbertoldi/Simulations/tests"

var <- 'soil_moisture_content_50'

param <- c(N=1.4,Alpha=0.0021,ThetaRes=0.05,LOG10_SOIL__NormalHydrConductivity=-1) 
ssout <- geotopGOF(x=param,run.geotop=TRUE,bin=bin,
<<<<<<< HEAD
		simpath=wpath,runpath=runpath,clean=FALSE,data.frame=TRUE,
		level=1,intern=TRUE,temporary.runpath=FALSE)

=======
		simpath=wpath,runpath=runpath,clean=TRUE,data.frame=TRUE,
		level=1,intern=TRUE,temporary.runpath=TRUE)
		
ssout
>>>>>>> a782e4494ecf83d25b4c81a9bd28ab2796448a39

#
