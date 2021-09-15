#!/bin/bash
#
#SBATCH --job-name=example_script
#SBATCH --qos=blanca-ics
#SBATCH --partition=blanca-ics
#SBATCH --account=blanca-ics-training
#SBATCH --time=00:05:00
#SBATCH --array=1-100%10
#SBATCH --output=logs/example_%A_%a.out
#SBATCH --error=logs/example_%A_%a.err
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10M

# ---------------------------------------------------------------------------------------
# EXAMPLE: Job Array
#
# Description: generate new text files from an input list. 
#              Run multiple jobs in parallel HPC 
#
# SYNTAX: job_array.sh 
#
# Created: 2021-09-15 AKH
#
# ---------------------------------------------------------------------------------------

# Use the SLURM_ARRAY Index increment the script between each iteration of the array job.
#    we will use the the index to select a row from our list
NUM=$SLURM_ARRAY_TASK_ID
WORD=$(sed -n "$NUM"p word_list.txt)

# generate a new text file with the filename provided...
touch $HOME/outputs/${WORD}.txt

# sleep for 30 seconds (used to test queue progression)
sleep 30s



# END_SCRIPT
