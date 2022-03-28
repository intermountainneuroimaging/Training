# ----- UNDER CONSTRUCTION ----- 




# fMRI Surface Based Analysis 

Suface based analyses are becoming increasingly popular as a method to locate neural activation and resting state connectivity in fMRI. Surface based analysis provide the advantage of disentangling activation (or neural signal) measured near one another on the folded cortex. Surfaces can be 'unfolded' to perform spatial smoothing or distance dependent analyses. Important to note, surface based analyses are generally constrained to the cortex, while there are models of cerebelum surfaces these are not whilely availible to date.

To perform surface based analyses, an accurate reconstruction of the cortex is required from a high resolution T1w (and T2w if possible) image. Many methods have been adopted to generate surface based results, and generally two methods are accepted: (1) perform preprocessing in volume space, sample GLM results to surface map; (2) perform preprocessing in surface space, fit GLM in surface space.

Please consult these references to get you started:


## Using Surfaces Based Tools with FEAT
Freesufer has developed a set of surface based tools to interact with the FEAT model structure. This provides an easily integrated domain for comparing traditional volume based statistics maps and surface based statistics maps.

Petalibrary users can access a set of wrapper tools located here:
```
export PATH="/projects/ics/tools/surface_anlys:$PATH"

#tools include:
fsfeat_1_reg
fsfeat_2_stats
```

These wrappers use freesufer tools:
```
reg-feat2anat  # Used to generate surface registration within feat 1st level model data strucutre
feat2surf      # Used to sample feat outputs onto surface within chosen template space
mri_glmfit     # group stats command for running statistics on surface (or volume) based models

```

Which use a pre-generated freesufer surface reconstruction and pre-generated feat first level model for the same subject / session. Using the computed registration matix between the functional and high res space for the subject, freesurfer generates a new registration from the functional space to surface space. Next, the functional results are sampled onto the surface and registered together in the standard MNI space. Finally, group level statistics are run (fixed and random effect models can be used). 

**Check out the INC tutorial to use the wrapper scripts on CURC resources (here)[].**

# Using Surface Based Tools in AFNI
An alternative method is to use AFNI for surface based analysis. AFNI, which includes a suite of tools for fMRI preprocessing, model fitting, and group analysis also includes built in surface based tools. If you are interested in running fMRI preprocessing in surface space, this is probabaly the right tool for you! 

Follow the totorial linked here for using AFNI to run a surface based analysis (or full preprocessing pipeline)
(link)[]. 
