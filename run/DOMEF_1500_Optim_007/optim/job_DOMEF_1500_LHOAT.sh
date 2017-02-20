#$ -N DOMEF_1500_007_LHOAT_MonaLisa
#$ -V
#$ -pe mpich 16 # number of cores: 
#$ -M giacomo.bertoldi@eurac.edu,samuel.senoner@eurac.edu
#$ -m beas  # all job events sent via email
#$ -l h_rt=4:00:00
#$ -o $HOME/Simulations/MonaLisaSims/
#$ -e $HOME/Simulations/MonaLisaSims/

#### bash script for job for sensitivity 1D GEOtop simulations with GEOtop Optim for monalisa station

# name of the optimization script. Ir should be in the same folder of the present bash script
export LHOAT_SCRIPT=lhoat_DOMEF_1500.R

### root directory where there are the input data: the base simulation and the list of parameters that you optimize 
export GEOTOPOPTIM2_PROJECT_DIR=$HOME/Simulations/MonaLisa

# the base simulation name
export GEOTOP_FOLDER=DOMEF_1500_Optim_007

### temporary working directory. Be aware that sometimes the folder tmp should be emptied
export GEOTOPOPTIM2_TEMP_DIR=/tmp/geotopOptim_test2np

### folder where you find the final optimized simulation
export GEOTOPOPTIM2_SAVE_DIR=$HOME/Simulations/MonaLisaSims


mkdir $GEOTOPOPTIM2_TEMP_DIR
mkdir -p $GEOTOPOPTIM2_SAVE_DIR/$GEOTOP_FOLDER

#export I_MPI_PIN_PROCESSOR_LIST=1,14,9,6,5,10,13,2,3,12,11,4,7,8,15,0
####mpirun -machinefile $TMPDIR/machines -np $NSLOTS

R CMD BATCH $LHOAT_SCRIPT $GEOTOPOPTIM2_SAVE_DIR/$GEOTOP_FOLDER/psolhoat_monalisa_$GEOTOP_FOLDER.Rout

#rm -rf $GEOTOPOTIM2_TEMP_DIR
