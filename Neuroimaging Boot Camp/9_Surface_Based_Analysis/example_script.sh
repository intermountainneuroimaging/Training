#EXAMPLE SCRIPT FOR USING SURFACE BASED MODELS
# This tool leverages freesurfer tools resample FEAT results to surface space

# These tools are a work in progress! Questions or concerns, contact:
# Amy Hegarty, amy.hegarty@colorado.edu

# add surface tools to path
export PATH="/projects/ics/tools/surface_analysis_tools/:$PATH"

# load required software - setup for CURC HPC
module use /projects/ics/modules
module load fsl/6.0.3
module load freesurfer/7.1.0

# set SLURM variables for fsl_sub submissions
export FSL_SLURM_UCB_ACCOUNT=blanca-ics-ldrc
export FSL_SLURM_PARTITION_NAME=blanca-ics
export FSL_SLURM_QUEUE_NAME=blanca-ics
export FSL_SLURM_WALLTIME_MINUTES=1440
export FSL_SLURM_MB_RAM=8G
export FSL_SLURM_XNODE_NAME=bnode0101,bnode0102,bnode0103,bnode0104,bnode0105

# ------------------------------------------- #
# STEP 1: create a list of lower level feat 
#         models for surface analysis
# pattern: <subject-id> <featdir>
more nback_feat.list

# ------------------------------------------- #
# STEP 2: set run registration between feat 
#         and freesurfer surfaces
export SUBJECTS_DIR=<path-to-freesurfer-subjects>

# run fsfeat registration for all subjects
while read subjid featid ; do 
	logdir=logs/$subjid ; mkdir -p $logdir

	# run fsfeat registration for all subjects
	cmd="fsfeat_1_reg $featid $subjid"
    fsl_sub -n 2 -N fsfeat_1_reg -l $logdir $cmd
done < nback_feat.list

# --- wait until finished.. --- 

# ------------------------------------------- #
# STEP 3: Run stats
#
resultsdir=nback_114subj
logdir=$resultsdir/logs; mkdir -p $logdir

cmd="fsfeat_2_stats nback_feat.list $resultsdir"
fsl_sub -n 2 -N fsfeat_2_stats -l $logdir $cmd

# ------------------------------------------- #
# STEP 4: View (uncorrected) Results 
#
freeview -f $SUBJECTS_DIR/fsaverage/surf/lh.inflated:annot=aparc.annot:annot_outline=1:overlay=$resultsdir/lh.cope1.osgm.rfx/osgm/sig.mgh:overlay_threshold=4,6 -viewport 3d

# NOTES: FreeSurfer uses -log10(p) notation; in other words, a value of 1 
#   in the sig.mgh map represents a p-value of 0.1, a value of 2 represents a 
#   p-value of 0.01, and so on.


# NEXT STEPS
# a permutation test to generate cluster corrected results...
# OPTIONS EXPLAINED:
#   --perm nsim CFT sign
#       We will use freesurfer's sim program, using a permutation sim 
#       comparisons using nsim iterations, a cluster forming threshold of 
#       CFT (in -log10(p) units), using the given contrast sign (pos, neg, abs).
#
#   --2spaces
#       addition correction for multiple comparisons for when the
#       current correction is part of a larger analysis including right and left hemisphere.
cmd="mri_glmfit-sim --glmdir $resultsdir/lh.cope1.osgm.rfx --sim-sign abs --sim perm 1000 3 abs --2spaces"
fsl_sub -n 2 -N fsfeat_3_sim -l $logdir $cmd

cmd="mri_glmfit-sim --glmdir $resultsdir/rh.cope1.osgm.rfx --sim-sign abs --sim perm 1000 3 abs --2spaces"
fsl_sub -n 2 -N fsfeat_3_sim -l $logdir $cmd


# show cluster corrected result
freeview -f $SUBJECTS_DIR/fsaverage/surf/lh.inflated:annot=aparc.annot:annot_outline=1:overlay=$resultsdir/lh.cope1.osgm.rfx/osgm/abs.sig.masked.mgh:overlay_threshold=1,6 -viewport 3d

freeview -f $SUBJECTS_DIR/fsaverage/surf/lh.pial:annot=aparc.annot:annot_outline=1:overlay=$resultsdir/lh.cope1.osgm.rfx/osgm/abs.sig.masked.mgh:overlay_threshold=1,6 -viewport 3d

# follow the steps outlined here to make a gif of the results
# https://surfer.nmr.mgh.harvard.edu/fswiki/makeagif
