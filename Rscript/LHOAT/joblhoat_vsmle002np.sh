#$ -N geotopoptim2_MonaLisa_lhoat
#$ -V
#$ -pe mpich 16
#$ -M emanuele.cordano@gmail.com,giacomo.bertoldi@eurac.edu,samuel.senoner@eurac.edu
#$ -m beas  # all job events sent via email
#$ -l h_rt=10:00:00
#$ -o $HOME/Simulations/MonaLisaSims/
#$ -e $HOME/Simulations/MonaLisaSims/
#$ -t 1-4

#### bash script for jon to optimize several 1D GEOtop simulations with GEOtop Optim for monalisa station

# in the file folders are the simulation names. In this case are 4 and above you have -t l-4 it means you ran the scipt 4 times one ofr each base simulation
export GEOTOP_FOLDERS=folders
export GEOTOP_FOLDER=$(awk "NR==$SGE_TASK_ID" $GEOTOP_FOLDERS)

export GEOTOPOPTIM2_TEMP_DIR=/tmp/geotopOptim_test2np

### folder where you find the final optimized simulation
export GEOTOPOPTIM2_SAVE_DIR=$HOME/Simulations/MonaLisaSims

### directory where there is the Monalisa project in github with the input data
export GEOTOPOPTIM2_PROJECT_DIR=$HOME/Simulations/MonaLisa

mkdir $GEOTOPOPTIM2_TEMP_DIR
mkdir -p $GEOTOPOPTIM2_SAVE_DIR/$GEOTOP_FOLDER

#export I_MPI_PIN_PROCESSOR_LIST=1,14,9,6,5,10,13,2,3,12,11,4,7,8,15,0
####mpirun -machinefile $TMPDIR/machines -np $NSLOTS

R CMD BATCH psolhoat_monalisa.R $GEOTOPOPTIM2_SAVE_DIR/$GEOTOP_FOLDER/psolhoat_monalisa_$GEOTOP_FOLDER.Rout

#rm -rf $GEOTOPOTIM2_TEMP_DIR
