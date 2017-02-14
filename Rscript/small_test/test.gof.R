#
#
# Author: Emanuele Cordano
#
# Test: tast simulation settings for GOF 


#

rm(list=ls())
library(geotopOptim2)

#wpath <-  '/home/ecor/local-projects/MonaLisa/run/DOMEF_1500_Optim_005' 

wpath <- "C:\\Users\\GBertoldi\\Documents\\Simulations_local\\MonaLisaSims_20170207\\DOMEF_1500_Optim_005"

##wpath <- system.file('geotop-simulation/B2site',package="geotopOptim2")
bin <-   "/home/ecor/local/geotop/GEOtop/bin/geotop-2.0.0"
runpath <- "/home/ecor/temp/geotopOptim_tests"

var <- 'soil_moisture_content_50'

param <- NULL ##c(N=1.4,Alpha=0.0021,ThetaRes=0.05) 
ssout <- geotopGOF(x=param,run.geotop=TRUE,bin=bin,
		simpath=wpath,runpath=runpath,clean=TRUE,data.frame=TRUE,
		level=1,intern=TRUE,temporary.runpath=TRUE)


#
