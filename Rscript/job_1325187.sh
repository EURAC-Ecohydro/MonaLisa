#$ -N geotopoptim2_MonaLisa_array_32
#$ -V
#$ -pe mpich 32
#$ -M emanuele.cordano@gmail.com
#$ -m beas  # all job events sent via email
#$ -l h_rt=02:00:00
#$ -t 1-4
export GEOTOP_FOLDERS=folders
export GEOTOP_FOLDER=$(awk "NR==$SGE_TASK_ID" $GEOTOP_FOLDERS)

export GEOTOPOPTIM2_TEMP_DIR=/tmp/geotopOtim2_tempdir
export GEOTOPOPTIM2_SAVE_DIR=/home/lv70864/ecordano/Simulations/MonaLisaSims
export GEOTOPOPTIM2_PROJECT_DIR=/home/lv70864/ecordano/Simulations/MonaLisa

mkdir -p $GEOTOPOTIM2_TEMP_DIR
mkdir -p $GEOTOPOTIM2_SAVE_DIR

export I_MPI_PIN_PROCESSOR_LIST=1,14,9,6,5,10,13,2,3,12,11,4,7,8,15,0


 
mpirun -machinefile $TMPDIR/machines -np $NSLOTS R CMD BATCH pso_monalisa.R pso_monalisa_$GEOTOP_FOLDER.Rout
#####R CMD BATCH pso_example_script_monalisa_vsmle2.R  


#mkdir $GEOTOPOTIM2_SAVE_DIR/saved
#mv $GEOTOPOTIM2_SAVE_DIR $GEOTOPOTIM2_SAVE_DIR/saved

######rm -rf $GEOTOPOTIM2_TEMP_DIR



