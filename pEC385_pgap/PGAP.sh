#!/bin/bash
# Program: 
#SBATCH -J PGAP
#SBATCH -n 8
#SBATCH -N 1
#SBATCH --array=1%1

#module purge
#module load PGAP/build5508

/mnt/d/Sequence_ubuntu/PGAP/pgap.py \
	pEC385.yaml \
	-o pEC385_PGAP_results_2 \
	--ignore-all-errors \
	-r \
	
/mnt/d/Sequence_ubuntu/PGAP/pgap.py --version

echo "Pepegasad"
