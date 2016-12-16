# MonaLisa
This  project contains GEOtop simulation templates to be used used within  [R/geotopOtim2](https://github.com/ecor/geotopOptim2) framework.  


The project MONALISA is the starting point of a multi-annual special research area, founded by the Autonomous Province of Bolzano / Bozen. Aim of both MONALISA and the special research area is to increase the collaboration within the South Tyrolean research system (EURAC, Free University Bolzano, VZ Laimburg, TIS ֠Innovation Park). The whole production chain of agriculture will be monitored from environmental conditions to the quality of apples. Multi-scale means that key environmental parameters will be consistently monitored across scales from regional scale (full area of South Tyrol, 7400kmҩ, landscape scale, plot scale down to the level of plants, fruits and leaves. In the laboratory, Laimburg will analyze fruit texture and tissue with NDT.

In this dataset are reported  the input data to simulate whith the GEOtop hydrological model time series of several environmental variables in agricultural sites monitored in the project MONALISA.(Deliverable 2.3.1.2), .

Variables include the full surface energy budget, i.e. latent and sensible heat fluxes (LE and H), ground heat flux (G), shortwave radiation (Rsw), net radiation (Rn), soil water budget, i.e. evapotranspiration (ET), soil moisture content (SMC), soil water potential (SWP), precipitation (P), snow water equivalent (SWE). The complete list of the simulated variables is contained in the supplementary information box.

Results have been obtained by calibrating the GEOtop model with respect to SMC observations, using the geotopOptim2 R package.

More details on the employed ground observations could be found here: http://monalisasos.eurac.edu/sos/ 

Information on the GEOtop model can be found here: http://geotopmodel.github.io/geotop/ 

Documentation on the simulated variable could be found here: http://geotopmodel.github.io/geotop/materials/geotop_manuale.pdf 

The source code version of the model used for the simulations could be found here: https://github.com/geotopmodel/geotop/tree/se27xx 

