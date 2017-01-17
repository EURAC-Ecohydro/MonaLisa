#$ -N lht002np
#$ -V
#$ -pe mpich 16
##$ -l h_rt=06:00:00
#$ -M giacomo.bertoldi@eurac.edu
#$ -m beas  # all job events sent via email

#export I_MPI_PIN_PROCESSOR_LIST=1,14,9,6,5,10,13,2,3,12,11,4,7,8,15,0
export GEOTOPOTIM2_TEMP_DIR=/tmp/geotopOptim_test2np
mkdir $GEOTOPOTIM2_TEMP_DIR

####mpirun -machinefile $TMPDIR/machines -np $NSLOTS

R CMD BATCH psolhoat_example_script_vsmle002np.R

#rm -rf $GEOTOPOTIM2_TEMP_DIR