# Interacting with Large Datasets: Best Practices

With the push for open science, the availiblity of public neuroimaging datasets has drastically advanced in recent years, with many more datasets being shared each year. Scientific governing bodies such as the NIH, NSF, and others have put high priority on open science data for several reasons:
1. Increase reporducibility of published work
2. Increase exploration of new analytic techniques on existing data
3. Expand research knowledge gained from any federally funded experiment

We will outline new best practices at the Intermountain Neuroimaging Consortium to support our users in participating in open science. All computations will be run using University of Coloraodo at Boulder Reserach Computing (CURC) compute cluster. If you do not have access to CURC please follow the steps [here](https://rcamp.rc.colorado.edu/accounts/account-request/create/organization) to get started.

**Learning Objectives:**
- Use CURC resources (SUMMIT or BLANCA high performance compute) to pull open access data
- Use CURC large capactity file system for open access data storage (*currently only availible for SUMMIT*)
- List guidelines for CURC **SUMMIT** scratch file system for data storage
- Explore the use of open access data best practices

## Summit Scratch File System...

For many research purposes, a local copy of open science data may be needed for additional computation or statistical analysis. Find a list of filesystems availible to CURC users below.

|  | <h5>Location</h5> | <h5>Quota</h5> | <h5>Use</h5> | <h5>Snapshot Backups</h5> | <h5>Name</h5> |
| --- | --- | --- | --- | --- | --- |
| <h5>Home Directory</h5> | Mounted read-write on all RC resources | 2 GB | Personal storage | yes | /home/<user>
| <h5>Projects Directory</h5> | Mounted read-write on all RC resources | 250 GB | Personal storage, Not high performance | yes | /projects/<user>
| <h5>Summit Scratch Filesystem</h5> | Mounted read-write on all **SUMMIT** nodes (login, compute) | 10 TB (increased on request) | Not for long-term data storage; files created more than 90 days in the past are automatically purged. | no | /scratch/summit/<user>
| <h5>Summit Scratch Datasets Filesystem</h5> |  Mounted read-write on compute and compile **SUMMIT** nodes only | temporary or long term storage of reproducible data files | No Limit (soft quota 40 TB) | no | /gpfs/summit/datasets/ICS
| <h5>Blanca/CUmulus Scratch Filesytem</h5> | Not Accessible (Go Live Summer 2022) | temporary or long term storage of reproducible data files | No Limit (soft quota 40 TB) | no | ??


### Summit Scratch Datasets Filesystem

INC best practices, we recommend you use **Summit Scratch Datasets Filesystem** to store all open access datasets. As this filesystem is a *community* resource, please remember:
 - **Always** check owner and group permissions for directory structure and files
 - Include a README.txt or similar file to describe the dataset (include data use agreements as needed and exporiation dates for locally stored files)
 - Do not store any derivative/computational output data -- these files must be moved to your team's PetaLibrary allocation
 - Use clear naming conventions for all files


### Summit Scratch Filesystem

If you are looking for a storage location with more flexiblity, consider using **Summit Scratch User Filesystem** where each user (or lab) can have a seperate large capacity work space. Remember these files are purged after 90 days so all long term storage files should be moved to permanent storage on PetaLibrary. 

## Summit Compute Resources 

If you are not familiar with using reserach computing compute resources on Blanca, please visit the INC Basic Training modules [here](https://docs.google.com/document/d/1hxN2ZC7WGrJ8e2KCV2xaf5U1t501QcZOVm9SO2vlRIQ/edit?usp=sharing).

Summit Computing Cluster is a free, University funded computing cluster managed by CURC. <br>

***To login:***
```bash
ssh -X <identikey>@login.rc.colorado.edu
```

### Accessing Software Modules and Mounted Filesystems

To access modules or scratch mounted filesystems on **Summit** you must first launch a compile or compute node session

| | Bash Command | 
| --- | --- | 
| <h5>Compile Node</h5> | `ssh scompile` |
| <h5>Interactive Compute Node</h5> | `sinteractive --partition=shas --time=00:01:00 --nodes=1`| 

***Lets try it...***


```bash
# Run lauch compile session if you are not already on a compile or compute node
ssh scompile

# lets check which versions of python are availible
module spider python
```

    Rebuilding cache, please wait ... (written to file) done.
    
    ----------------------------------------------------------------------------
      python:
    ----------------------------------------------------------------------------
        Description:
          Python Programming Language
    
         Versions:
            python/2.7.11
            python/2.7.14
            python/3.5.1
            python/3.6.5
    
    ----------------------------------------------------------------------------
      For detailed information about a specific "python" module (including how to load the modules) use the module's full name.
      For example:
    
         $ module spider python/3.6.5
    ----------------------------------------------------------------------------
    



```bash
# next lets check which versions of FSL (ICS specific software) are availible
module use /projects/ics/modules
module spider FSL
```

    Rebuilding cache, please wait ... (not written to file) done
    
    ----------------------------------------------------------------------------
      fsl:
    ----------------------------------------------------------------------------
         Versions:
            fsl/4.1.8
            fsl/5.0.2.2
            fsl/5.0.4
            fsl/5.0.5
            fsl/5.0.6-slurm
            fsl/5.0.6
            fsl/5.0.7-test
            fsl/5.0.8
            fsl/5.0.9
            fsl/5.0.10
            fsl/5.0.11
            fsl/6.0.3
    
    ----------------------------------------------------------------------------
      For detailed information about a specific "fsl" module (including how to load the modules) use the module's full name.
      For example:
    
         $ module spider fsl/6.0.3
    ----------------------------------------------------------------------------
    


> **WARNING:** Some Custom Modules have issues on Summit based on the restrictive libs. Best practice is to use custom software within singularity containers instead of software modules.
>> ***If you run into problems contact Amy Hegarty or Lena Sherbakov***


### Priority Job Submissions on Summit

All CURC users may use the summit commuting cluster mostly on a first come first serve basis. For *heavy users*, pripority will be decreased when the queue is full, leading to longer wait time. If you are interested in testing your job scripts on Summit and need a priority account, please contact Amy Hegarty (Amy.Hegarty@colorado.edu) or Lena Sherbakov (Lena.Sherbakov@colorado.edu). 

***Priority Job submission:***
```bash
sbatch --qos=normal --partition=shas --account=<ICS-Account-Key>
```

Looking for more help? Check out research computing documentation [here](https://curc.readthedocs.io/en/latest/).

## Best Practices for Open Access Data

While keeping a duplicate copy of all the open access data you anticipate needing for your research on our local servers may sound appealing, lets stop and consider some pros and cons:

Open Access Data Duplicate on CURC ***Pros***:
- Fast and reliable access to your data any time
- Searchable metadata for all files
- ...

Open Access Data Duplicate on CURC ***Cons***:
- Expensive and occupies space on shared resources
- Duplicate of data already stored offsite
- Risk breaking privacy or time limits agreed to in Data Use Agreements

Since many researchers or institutions (including CU) are not ready to implement cloud based computing for cloud based datasets, we encourage all users to work towards a hybrid aproach where community datasets are retained only as long as ***necessary*** on CURC systems.

![public dataset best practices on CURC resources](https://github.com/intermountainneuroimaging/Training/blob/main/Neuroimaging%20Boot%20Camp/HPC:%20Large%20Datasets%20on%20Summit/support-images/Interacting-with-Public-Data-graphic.jpg)

## Next steps, lets try it on some open access data!

Most public data repositories have a command line interface (CLI) or application programming interface (API) so that users can programatically reterive small buckets of the dataset at one time. 

For example, amazon web services (AWS) has its own interface where you may interact with the data on the amazon servers, or download the data to work with it on CURC system. In the following tutorial we will show how you can use AWS to interact with the Human Connectome Project open access data.

Lets start by setting up where the data will go...


```bash
export SCRATCH_DIR=/gpfs/summit/datasets/ICS
```

We are going to work on a common training dataset [FSL Course Data](https://open.win.ox.ac.uk/pages/fslcourse/website/#Data). Static datasets can reside on the Summit Scratch Dataset Allocation *if appropriate*. FSL course data is intended for educational purposes only, and we will work thourgh the first part of their registration tutorial together using both modules and singularity containers. We hope this will be easily adaptable to your own pipelines.


```bash
# show all the datasets currently stored in the allocation
ls -l $SCRATCH_DIR

# we will be working with the fsl_course data
cd $SCRATCH_DIR/fsl_course_data
```

    total 0
    drwxr-x---  3 amhe4269 abcdgrp          4096 Nov 11 14:05 ABCD
    drwxr-x--- 14 amhe4269 pl-ics-community 4096 Nov 11 13:09 fsl_course_data
    drwxr-x---  4 amhe4269 hcpgrp           4096 Nov 11 11:08 hcp
    -rw-r--r--  1 ics      icspgrp           234 Oct 21 08:57 samplejob.sh
    drwxr-x---  4 amhe4269 icspowergrp      4096 Oct  8 10:59 snr_comparison


You can see that several datasets have restrictive access groups, such as abcdgrp for the ABCD dataset. If you are interested in using a dataset already downloaded on Summit Scratch Datasets please contact amy.hegarty@colorado.edu or lena.sherbakov@colorado.edu with proof of an active data use agreement (or equivalent).

### FSL - Registration Tutorial
This tutorial has been compressed from the FSL registration tutorial for the self paced [course](https://open.win.ox.ac.uk/pages/fslcourse/practicals/registration/index.html). 

> In this practical you will explore each of the registration steps within a standard two-step registration for functional images. Then we will see how to apply and invert transformations. Being able to achieve precise registrations is CRUCIAL for structural, functional and diffusion image analysis. If registrations are not accurate, further statistics at a structural or group level will not be accurate.
> <div style="text-align: right"><i> -- FSL Registration Tutorial </i></div>

#### Brain Extraction
...


```bash
cd $SCRATCH_DIR/fsl_course_data/registration

#load required fsl commands...
module use /projects/ics/modules
module load fsl/6.0.3

# make a results directory that we can push to a permanent location later!!
mkdir results_${USER}

# use fsl bet for brain extraction of the functional image
bet STRUCT.nii.gz results_${USER}/STRUCT_brain.nii.gz -m
```

#### Two Stage Registration EPI -> T1w -> Standard
...


```bash
# Run registration for functional image to standard data...
cd $SCRATCH_DIR/fsl_course_data/registration/results_${USER}

# define inputs
epifile=../FUNC.nii.gz
highres_head_file=STRUCT_brain.nii.gz
highres_file=../STRUCT.nii.gz
highres_mask_file=STRUCT_brain_mask.nii.gz
standard_file=$FSLDIR/data/standard/MNI152_T1_2mm_brain.nii.gz

# use center image as the example fun frame... 
let voln=`fslval $epifile dim4`
echo "Total original volumes: $voln"
centerval=`bc <<<"scale=0; $voln / 2"`
fslroi $epifile example_func $centerval 1

# registration of functional images can be completed using multiple tools, here we show epi_reg
echo "Running epi registration... May take several minutes to complete"
epi_reg --epi=example_func --t1=$highres_head_file --t1brain=$highres_file --out=example_func2highres

# register t1w to standard space
echo "Running T1w to Standard Space FLIRT..."
flirt -in $highres_file -ref $standard_file -out highres2standard -omat highres2standard.mat -cost corratio -dof 12 -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -interp trilinear

# add transforms...
convert_xfm -inverse -omat standard2highres.mat highres2standard.mat

# add transforms...
convert_xfm -omat example_func2standard.mat -concat highres2standard.mat example_func2highres.mat

# register example_func to standard space
echo "Applying func2standard transformations..."
flirt -ref $standard_file -in example_func -out example_func2standard -applyxfm -init example_func2standard.mat -interp trilinear

# register func to standard space
flirt -ref $standard_file -in $epifile -out func_data2standard -applyxfm -init example_func2standard.mat -interp trilinear 

# register brain mask to standard space
flirt -ref $standard_file -in $highres_mask_file -out mask2standard -applyxfm -init highres2standard.mat -interp nearestneighbour

# add transforms...
convert_xfm -inverse -omat standard2example_func.mat example_func2standard.mat

echo "Registration COMPLETE"

```

    Total origina volumes: 380
    Running FAST segmentation
    FLIRT pre-alignment
    Running BBR
    1.014470 0.995076 0.068426 0.071699 0.000000 -0.076077 0.991008 0.110067 0.000000 -0.063523 -0.114980 0.991335 0.000000 7.800981 -2.923377 -13.977699 1.000000 


#### Using Singularity Containers
...


```bash
img=/pl/active/ics/containers/fsl/fsl_v6.0.3.sif

# remove all active modules and load singularity
module prune
module load singularity/3.6.4

# call singularity version of fsl...
inputs=$SCRATCH_DIR/fsl_course_data/registration/
outputs=$SCRATCH_DIR/fsl_course_data/registration/results_${USER}

# We will use the exec option in singularity to simply execute a single command within the container enviornment
singularity exec -B $inputs:/data -B $outputs:/out $img bet /data/STRUCT.nii.gz /out/STRUCT_brain.nii.gz

```


```bash
# !! MOVE RESULTS OFF SCRATCH !!
mv $SCRATCH_DIR/fsl_course_data/registration/results_${USER} /projects/$USER/
```

Up Next!! ... Using database command line interfaces to interactively pull data using Amazon Web Services S3 Buckets and Datalad!!
