#!/usr/bin/env Rscript
# file psol_example_script_vsmle.R
#
# This script is an examples of a GEOtop PSO Calibration via geotopOptim2
#
# author: Emanuele Cordano on 16-10-2016

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
#### export MONALISA_TEMPDIR=/home/ecor/temp/monalisa

rm(list=ls())
options(warn=1)

library(zoo)
library(geotopOptim2)

## Set a seed for the random generation
set.seed(7999)
## This 'if' loop was introduced if hydroPSO has been worked on a MPI/parallel way 
## to optimize VSC performances.
## In these lines 'control' argument for 'lhoat' or 'hydroPSO' ('geotoplhoat' or 'geotopPSO') is set. See documentation: help(lhoat) or help(hydropso)  
USE_RMPI <- TRUE

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
	
	parallel <- "parallel"
	npart <- 31
	control <- list(maxit=10,npart=npart,parallel=parallel)
	
} else {
	
	parallel <- "none"
	npart <- 4
	control <- list(maxit=4,npart=npart)
	
}

## This 'if' loop was introduced to set the GEOtop binary file which be used in GEOtop 

USE_SE27XX <- TRUE

if (USE_SE27XX==TRUE) {
	
	##bin <- ' geotop-2.0.0'
	bin <- 'geotop_se27xx'
##bin<- '/home/ecor/local/geotop/GEOtop/bin/geotop-2.0.0'
	
} else {
	
	bin  <-  'geotop_dev'
	
}  


## MonaLisa sites

project_path0 <- '/home/ecor/local-projects/MonaLisa' 
project_path <- Sys.getenv("GEOTOPOPTIM2_PROJECT_DIR")
itsim <- Sys.getenv("GEOTOPOPTIM2_PROJECT_DIR")

if (project_path=="") project_path <- project_path0

geotopsims <- c("DOMEF_1500_Optim_001",
"Kaltern_Optim_001",
"Matsch_P2_DVE_Optim_001",
"DOMES_1500_Optim_001",
"Matsch_B2_DVM_Optim_001",
"Matsch_P2_Optim_001",
"DOPAS_2000_Optim_001","Matsch_B2_Optim_001")

wpath_geotopsims <- paste(project_path,"geotop",geotopsims,sep="/")

names(wpath_geotopsims) <-  geotopsims

paramfiles <- sprintf("param_%s.csv",geotopsims)
paramfiles <- paste(project_path,"param",paramfiles,sep="/")
names(paramfiles) <- geotopsims
runpath0 <- paste(project_path,"run",sep="/")
savepath0 <- paste(project_path,"save",sep="/")


## Choose the MonaLisa Site 


itsim <- Sys.getenv("GEOTOP_FOLDER") 
if (itsim=="") stop("GEOTOP FOLDER MISSING")
if (is.numeric(itsim)) itsim <- geotopsims[itsim] 


####for (itsim in geotopsims[-c(1,2,3,6,7)]) {
	
wpath <- wpath_geotopsims[itsim]
geotop.param.file <- paramfiles[itsim]






## Set time zone: here GMT+1 (solar time in Rome/Berlin/Zurich/Brussel)

tz <- "Etc/GMT-1"

## Set the full path for GEOtop simulation template

wpath <- wpath


wpath <- wpath_geotopsims[itsim]
geotop.param.file <- paramfiles[itsim]






## Set time zone: here GMT+1 (solar time in Rome/Berlin/Zurich/Brussel)

tz <- "Etc/GMT-1"

## Set the full path for GEOtop simulation template

wpath <- wpath


## Set a temporary path where to run GEOtop simulations

runpath <- Sys.getenv("GEOTOPOPTIM2_TEMP_DIR")
if (runpath=="") runpath <- runpath0
savepath <- Sys.getenv("GEOTOPOPTIM2_SAVE_DIR")
if (savepath=="") savepath <- savepath0
## Set/get  parameter calibartion values (upper and lower values and names)
## Here parameters are read from a CSV ascii files and then imported as a data frame

geotop.param.file <-  geotop.param.file ###system.file('examples_script/param/param_pso_cland002.csv',package="geotopOptim2") ###'/home/ecor/Dropbox/R-packages/geotopOptim/inst/examples_2rd/param/param_pso_test3.csv' 
geotop.param <- read.table(geotop.param.file,header=TRUE,sep=",",stringsAsFactors=FALSE)


## Parametrer value are saved as separate vactors: one for upper values , one for lower values, another for suggested value (only PSO not lhoat)
## Each vector elements must be named with parameter name in accordance with geotopOptim2 documention (see vignette)
lower <- geotop.param$lower
upper <- geotop.param$upper
x <- geotop.param$suggested
names(lower) <- geotop.param$name
names(upper) <- geotop.param$name
if (!is.null(x)) names(x) <- geotop.param$name


### Set Target Observed Variables (here are used the same names of observation file!)
### Set a scale value for each target values (here these values are proportial to its respenctive uncertainity error!) 
var <- c('soil_moisture_content_50','soil_moisture_content_200') ###,'latent_heat_flux_in_air','sensible_heat_flux_in_air')
uscale <- c(1,1) ### c(0.03,0.03,25,25)/0.03

names(var)  <- var
names(uscale) <- var


### Preparing diagram
dirsim <- paste(savepath,itsim,sep="/")
dir.create(dirsim)
dirPSO <- paste(savepath,paste(itsim,"PSO.out",sep="_"),sep="/")
control[["drty.out"]] <- dirPSO <- paste(savepath,paste(itsim,"PSO.out",sep="_"),sep="/")

pso <- geotopPSO(par=x,run.geotop=TRUE,bin=bin,
		simpath=wpath,runpath=runpath,clean=TRUE,data.frame=TRUE,
		level=1,intern=TRUE,target=var,gof.mes="RMSE",uscale=uscale,lower=lower,upper=upper,control=control,temporary.runpath=TRUE)




#dirPSO <- paste(savepath,paste(itsim,"PSO.out",sep="_"),sep="/")
######dir.create(dirPSO)


file.copy(from=runpath,to=dirsim,recursive=TRUE)
#######file.copy(from="PSO.out",to=dirPSO,recursive=TRUE)
save(pso,file=paste(savepath,itsim,"pso.rda",sep="/"))


if (USE_RMPI==TRUE) mpi.finalize()
