

# MonaLisa
This  project contains GEOtop simulation templates to be used used within  [R/geotopOtim2](https://github.com/ecor/geotopOptim2) framework.  


The project MONALISA is the starting point of a multi-annual special research area, founded by the Autonomous Province of Bolzano / Bozen. Aim of both MONALISA and the special research area is to increase the collaboration within the South Tyrolean research system (EURAC, Free University Bolzano, VZ Laimburg, TIS ֠Innovation Park). The whole production chain of agriculture will be monitored from environmental conditions to the quality of apples. Multi-scale means that key environmental parameters will be consistently monitored across scales from regional scale (full area of South Tyrol, 7400kmҩ, landscape scale, plot scale down to the level of plants, fruits and leaves. In the laboratory, Laimburg will analyze fruit texture and tissue with NDT.
More information on the project could be found at: http://www.monalisa-project.eu/ 

In this dataset are reported  the input data to simulate whith the GEOtop hydrological model time series of several environmental variables in agricultural sites monitored in the project MONALISA.(Deliverable 2.3.1.2), .

Variables include the full surface energy budget, i.e. latent and sensible heat fluxes (LE and H), ground heat flux (G), shortwave radiation (Rsw), net radiation (Rn), soil water budget, i.e. evapotranspiration (ET), soil moisture content (SMC), soil water potential (SWP), precipitation (P), snow water equivalent (SWE). The complete list of the simulated variables is contained in the supplementary information box.

Results have been obtained by calibrating the GEOtop model with respect to SMC observations, using the geotopOptim2 R package.

More details on the employed ground observations could be found here: http://monalisasos.eurac.edu/sos/ 

Information on the GEOtop model can be found here: http://geotopmodel.github.io/geotop/ 

Documentation on the simulated variable could be found here: http://geotopmodel.github.io/geotop/materials/geotop_manuale.pdf 

The source code version of the model used for the simulations could be found here: https://github.com/geotopmodel/geotop/tree/se27xx 

Simulation names:

•	DOMEF_1500_Optim_001	Station Name DOMEF1500 Land use: meadow
CoordinatePointX	=	688655 CoordinatePointY	=	5141530
PointElevation		=	1415 PointSlope		=	1	PointAspect		=	300

•	DOMES_1500_Optim_001	Station Name DOMES_1500 Land use: meadow
CoordinatePointX	=	688074 CoordinatePointY	=	5141091
PointElevation		=	1473 PointSlope		=	27	PointAspect		=	180

•	DOPAS_2000_Optim_001	Station Name DOPAS_2000Land use: meadow
CoordinatePointX	=	688359.5 CoordinatePointY	=	5135797
PointElevation		=	2062 PointSlope		=	27 PointAspect		=	180

•	Kaltern_Optim_001
Station Name Kaltern LUB Land use: apple orchard
CoordinatePointX	=	674401.2 CoordinatePointY	=	5135433
PointElevation		=	214.294 PointSlope			=	0 PointAspect			=	225
	
•	Matsch_B2_DVM_Optim_001 Station Name Matsch B2_1500 Land use: meadow
Settings: time-variable vegetation phenology from dynamic vegetation model
CoordinatePointX	=	620815 CoordinatePointY	=	5171506
PointElevation		=	1480 PointSlope			=	15 PointAspect			=	225
	
•	Matsch_B2_Optim_001	Station Name Matsch B2_1500 Land use: meadow
CoordinatePointX	=	620815 CoordinatePointY	=	5171506 PointElevation		=	1480 PointSlope			=	15 PointAspect			=	225

•	Matsch_P2_DVE_Optim_001 Station Name Matsch P2_1500 Land use: pasture
Settings: imposed time-variable vegetation phenology
CoordinatePointX	=	621227 CoordinatePointY	=	5171306
PointElevation		=	1549 PointSlope			=	21.4 PointAspect			=	221.6
	
•	Matsch_P2_Optim_001	Station Name Matsch P2_1500 Land use: pasture
CoordinatePointX	=	621227 CoordinatePointY	=	5171306
PointElevation		=	1549 PointSlope			=	21.4 PointAspect			=	221.6

•	Latsch1_Calib_001	Station Name Latsch1 Beratungsring Land use: apple orchard
CoordinatePointX	=	641470 CoordinatePointY	=	5164589
PointElevation		=	641 PointSlope			=	0 PointAspect			=	0


