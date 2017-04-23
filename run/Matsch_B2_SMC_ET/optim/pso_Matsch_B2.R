#!/usr/bin/env Rscript
# file psol_example_script_vsmle.R
#
# This script is an examples of a GEOtop PSO Calibration via geotopOptim2
#
# author: Emanuele Cordano on 16-10-2016 and Giacomo Bertoldi on 7-03-2016

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

rm(list=ls()) # clean all variables
options(warn=1) # write the warnings

library(zoo)
library(geotopOptim2)

## Set a seed for the random generation
set.seed(7999)
## This 'if' loop was introduced if hydroPSO has been worked on a MPI/parallel way 
## to optimize VSC performances.
## In these lines 'control' argument for 'lhoat' or 'hydroPSO' ('geotoplhoat' or 'geotopPSO') is set. See documentation: help(lhoat) or help(hydropso)  

## this script uses MPI (you need to have intstalled the following package 
## install_git("https://gitlab.inf.unibz.it/Samuel.Senoner/hydroPSO")

# use with MPI; HydroPso package should be updated for using with MPI
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
	# npart particles number maxit number of iterations the number of simulations is (npart x maxit) 
	# under MPI is reccommenred  a multiple of (# of cores - 1)
	mynpart <- mpi.universe.size()-1  
	mymaxit <- 20
	# control is the list of all the control arguments in hydropso. See hydropso documentation
	control <- list(maxit=mymaxit,npart=mynpart,parallel=parallel,REPORT=10,K=25,normalise=TRUE)
	
} else {
	
# you define here some parameters
# npart: number of particles ; used only for optimizazion, not for sensitivity
# N: number of realizazion to divide each parameter range: 
# used for sensitivity only; total number of simulations should be N * (#parameters +1 )
# REPORT: frequency of report messages printed on screen

	parallel <- "none"
	npart <- 4
	control <- list(maxit=4,npart=npart)
	
}

## This 'if' loop was introduced to set the GEOtop binary file which be used in GEOtop 

USE_SE27XX <- TRUE

## define the name of GEOtop executable file 
if (USE_SE27XX==TRUE) {
	
	##bin <- ' geotop-2.0.0'
	bin <- 'geotop_se27xx'
##bin<- '/home/ecor/local/geotop/GEOtop/bin/geotop-2.0.0'
	
} else {
	
	bin  <-  'geotop_dev'
	
}  

##################################
## MonaLisa sites

# you apecify here the root directory where are the data (Monalisa github repository)  
# defined in the job bash script i.e. $HOME/Simulations/MonaLisa
project_path <- Sys.getenv("GEOTOPOPTIM2_PROJECT_DIR") 
#itsim <- Sys.getenv("GEOTOPOPTIM2_PROJECT_DIR")

## Set a temporary path where to run GEOtop simulations specified in the job bash script (job_allnew.sh) 
runpath <- Sys.getenv("GEOTOPOPTIM2_TEMP_DIR")

## Set a  path where to save final GEOtop simulations specified in the job bash script (job_allnew.sh) 
savepath <- Sys.getenv("GEOTOPOPTIM2_SAVE_DIR")

# you need absolute paths and names of:
# itsim
# geotop.param.file
# wpath

itsim <- Sys.getenv("GEOTOP_FOLDER") 
if (itsim=="") stop("GEOTOP FOLDER MISSING")


## Set the full path for GEOtop simulation template
# simulaton ther you will run as specified in GEOTOP_FOLDER

wpath <- paste(project_path,"run",itsim,sep="/")

## Set time zone: here GMT+1 (solar time in Rome/Berlin/Zurich/Brussel)
tz <- "Etc/GMT-1"

## Set parameter calibartion values (upper and lower values and names)
## Here parameters are read from a CSV ascii files and then imported as a data frame
paramfiles <- sprintf("param_%s.csv",itsim)
geotop.param.file <- paste(project_path,"run",itsim,"optim",paramfiles,sep="/")
geotop.param <- read.table(geotop.param.file,header=TRUE,sep=",",stringsAsFactors=FALSE)


## Parametrer value are saved as separate vectors: one for upper values , one for lower values, another for suggested value (only PSO not lhoat)
## Each vector elements must be named with parameter name in accordance with geotopOptim2 documention (see vignette)
lower <- geotop.param$lower
upper <- geotop.param$upper
x <- geotop.param$suggested
names(lower) <- geotop.param$name
names(upper) <- geotop.param$name
if (!is.null(x)) names(x) <- geotop.param$name

### Here you define the taget observed variables you want to optimize
# the variable names should correspond to what is defined in the file lookup_tbl_observation.txt in each simulation folder
# you define also hoe to scale different variables for the target function as a pnorm

### Set Target Observed Variables (here are used the same names of observation file!)
### Set a scale value for each target values (here these values are proportial to its respenctive uncertainity error!) 
var <- c('soil_moisture_content_50','latent_heat_flux_in_air') ###,'latent_heat_flux_in_air','sensible_heat_flux_in_air')
uscale <- c(0.03,0.25)/0.03 ### c(0.03,0.03,25,25)/0.03

names(var)  <- var
names(uscale) <- var


### Preparing diagram
### you create the directory with all the pso optimization output in a subfolder of GEOTOPOPTIM2_SAVE_DIR with the specific suimulation name
dirsim <- paste(savepath,itsim,sep="/")
dir.create(dirsim)
dirPSO <- paste(savepath,paste(itsim,"PSO.out",sep="_"),sep="/")
# you add this path to the pso control list
control[["drty.out"]] <- dirPSO <- paste(savepath,itsim,paste(itsim,"PSO.out",sep="_"),sep="/")

### print  fileames and settings to check script
print("Filenames and settings")
print(paste("itsim = ", itsim))
print(paste("project_path = ", project_path))
print(paste("wpath = ", wpath))
print(paste("savepath = ", savepath))
print(paste("runpath = ", runpath))
print(paste("dirsim = ", dirsim))
print(paste("dirPSO = ", dirPSO))
print(paste("bin = ", bin))
print(paste("geotop.param.file = ", geotop.param.file))
print(paste("itsim = ", itsim))
print("COntrol list")
control


#### here you finally launch the optimization (level is the the number of control file of GEOtop)
pso <- geotopPSO(par=x,run.geotop=TRUE,bin=bin,
		simpath=wpath,runpath=runpath,clean=TRUE,data.frame=TRUE,
		level=1,intern=TRUE,target=var,gof.mes="RMSE",uscale=uscale,lower=lower,upper=upper,control=control,temporary.runpath=TRUE,digits=6)


#dirPSO <- paste(savepath,paste(itsim,"PSO.out",sep="_"),sep="/")
######dir.create(dirPSO)

# copies the final temporary simulation to the folder where you save the final data
file.copy(from=runpath,to=dirsim,recursive=TRUE)
#######file.copy(from="PSO.out",to=dirPSO,recursive=TRUE)
save(pso,file=paste(savepath,itsim,"pso.rda",sep="/"))




if (USE_RMPI==TRUE) mpi.finalize()
