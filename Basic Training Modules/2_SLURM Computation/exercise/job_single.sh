#!/bin/bash
#
#SBATCH --job-name=example_script
#SBATCH --qos=blanca-ics
#SBATCH --partition=blanca-ics
#SBATCH --account=blanca-ics-training
#SBATCH --time=00:05:00
#SBATCH --output=logs/example.o%j
#SBATCH --error=logs/example.e%j
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10M
#SBATCH --ndoelist=bnode0101,bnode0301

# ---------------------------------------------------------------------------------------
# EXAMPLE: Single Run
#
# Description: generate new text file, use the name provided in script call, run on HPC
#
# SYNTAX: job_single.sh FILENAME
#
# Created: 2021-09-15 AKH
#
# ---------------------------------------------------------------------------------------

# input filename
WORD=${1:-file} 

# generate a new text file with the filename provided...
touch $HOME/outputs/${WORD}.txt

# sleep for 30 seconds (used to test queue progression)
sleep 30s



# END_SCRIPT
