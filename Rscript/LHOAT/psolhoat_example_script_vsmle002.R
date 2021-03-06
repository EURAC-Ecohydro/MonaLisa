#!/usr/bin/env Rscript
# file pso_example_script.R
#
# This script is an examples of a GEOtop lhoat via geotopOptim2
#
# author: Emanuele Cordano on 09-09-2015

#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.

###############################################################################


# clear all variables in memory
rm(list=ls())


library(zoo)
library(geotopOptim2)

#Rpath <- '/home/ecor/Dropbox/R-packages/geotopOptim2/R' 
#lf <- list.files(Rpath,pattern=".R",full.names=TRUE)
#for (it in lf) source(it)

#source('/home/ecor/Dropbox/R-packages/geotopOptim2/R/geotop.pso.2.R')
#source('/home/ecor/Dropbox/R-packages/geotopOptim2/R/geotop.execution.R') 

# seet to generate random simulations
# with the same seed same random sequence is generated
set.seed(7988)

# flag to use with MPI; HydroPso package should be updated for using with MPI
USE_RMPI <- FALSE 

if (USE_RMPI==TRUE) {
	library("parallel")

	library(Rmpi)
	require(snow)

	if (mpi.comm.rank(0) > 0) {
	    sink(file="/dev/null")
		#runMPIslave()
		slaveLoop(makeMPImaster())
		mpi.quit()
	}
	
	# creates a list of control parameters of hydropso
	parallel <- "parallel"
    npart <- 16
	control <- list(N=20) ###list(maxit=5,npart=npart,parallel=parallel)
	
} else {

# you define here some parameters
# npart: number of particles ; used only for optimizazion, not for sensitivity
# number of realizazion to divide each parameter range: total number of simulations should be N * (#parameters +1 )
# frequency of report messages printed on screen
	
	parallel <- "none"
	npart <- 4  
	control <- list(N=20,parallel="parallel",REPORT=40) ##list(maxit=5,npart=npart)
	
}

# specify the time zone. Is needed by geotopbricks
tz <- "Etc/GMT-1" # this is solar time in Rome (signs are opposite to UTC)

# specify il working  path della simulazione
#wpath <- system.file('geotop-simulation/B2site',package="geotopOptim2")
wpath <- '/home/lv70864/gbertoldi/Simulations/geotopOptim2_tests/Matsch_B2_Optim_001'

# flag to choose GEOtop executable
USE_SE27XX <- TRUE

if (USE_SE27XX==TRUE) {
	
	##bin <- ' geotop-2.0.0'
	bin <- 'geotop_se27xx'
	
} else {
	
	bin  <-  'geotop_dev'
	
}  ##bin  <-'/home/ecor/local/geotop/GEOtop/bin/geotop-2.0.0' 

## LOcal path where to write output for PSO
##runpath <- "/home/ecor/temp/geotopOptim_tests"
runpath <- Sys.getenv("GEOTOPOTIM2_TEMP_DIR")

# you specify here the file with the pameters to optimize/sentitive with ranges

#geotop.param.file <-  system.file('examples-script/param/param_pso_cland002.csv',package="geotopOptim2") 
geotop.param.file <-  'param_pso_cland_vsmle002.csv'
geotop.param <- read.table(geotop.param.file,header=TRUE,sep=",",stringsAsFactors=FALSE)
lower <- geotop.param$lower
upper <- geotop.param$upper
x <- geotop.param$suggested
names(lower) <- geotop.param$name
names(upper) <- geotop.param$name
if (!is.null(x)) names(x) <- geotop.param$name

# Variabilies target defined as keywords of observed variables in the observation file and in the lookup table
var <- c('soil_moisture_content_50','soil_moisture_content_200','latent_heat_flux_in_air','sensible_heat_flux_in_air')

# Vector used in geotopGOF when you optimize a target including multiple variables
# Before is calculated the choosen marginal GOF for each target variable, 
# then the variables are rescaled and adimensinalized dividing by a scale number based on the expected accuracy  
# more details in help geotopGOF
uscale <- c(0.03,0.03,25,25)/0.03

names(var)  <- var
names(uscale) <- var

# here I launch the sensitivity using lhoat
lhoat <- geotoplhoat(par=x,run.geotop=TRUE,bin=bin,
		simpath=wpath,runpath=runpath,clean=TRUE,data.frame=TRUE,
		level=1,intern=TRUE,target=var,gof.mes="RMSE",uscale=uscale,lower=lower,upper=upper,control=control)

# output file with some additional results
file_lhoat <-  'lhoat_n.rda' 
save(lhoat,file=file_lhoat)

if (USE_RMPI==TRUE) mpi.finalize()

# In the same folder where there is the script it will create a folder called LH_OAT with the output files.
# LH_OAT-Ranking.txt
# LH_OAT-gof.txt
# LH_OAT-out.txt
# LH_OAT-logfile.txt
# parallel-logfile.txt


