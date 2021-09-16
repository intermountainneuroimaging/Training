
# Welcome to the HPC Computing Tutorial for Advanced Users

The goal of this module is to discuss key features of SLURM job submission including measuring CPU and memory (RAM) usage, submitting multiple jobs in parallel, and best practices for ICS members planning to regularly use blanca-ics compute nodes. 

If you have not already done so, please review the core INC data and analysis training module [here](https://docs.google.com/document/d/1hxN2ZC7WGrJ8e2KCV2xaf5U1t501QcZOVm9SO2vlRIQ/edit#). We will build on the foundation established in the prior module in this module. 

In this lesson we will learn:
 - basics of submitting compute jobs
 - checking job status
 - running multiple jobs in parallel
 - properly reserve resources for computations

## High Performance Computing (HPC)
An HPC cluster is a collection of many separate servers (computers), called nodes, which are networked together. There are a number of different specifications for each computers (or nodes) that could be specialized for different tasks such as GPU nodes, high speed processor nodes, etc. 

High performance computing clusters generally include: 

 - head / login node - used as the interface between the compute environment and users
 - a specialized data transfer node (DTN)
 - regular compute nodes (where majority of computations is run)
 - GPU nodes (on these nodes computations can be run both on CPU cores and on a Graphical Processing Unit)

All cluster nodes have the same components as a laptop or desktop: CPU cores, memory and disk space (and sometimes GPU cores). The difference between a personal computer and a cluster node is in quantity, quality and power of the components. Importantly, cluster nodes are networked together so you can use resources from multiple nodes in tandem if desired.

## Common SLURM Commands and Settings
SLURM is the job scheduler used on the University of Colorado at Boulder HPC cluster. This system is used to run any compute job on the HPC nodes, and manages the resources of all nodes across the cluster. You should be familiar with basic SLURM commands after completing our basic training module here. We will discuss three primary SLURM commands and the most commonly used flags (or options) for each command.

```
# start in home directory ... as always
cd $HOME

# To start... some documents from today's tutorial are stored on github, lets make a local copy
git clone https://github.com/intermountainneuroimaging/Training.git
cd "Training/Basic Training Modules/2_SLURM Computation"

# take a quick look at what's here
ls 
```

New, lets look at all the nodes we have to work with...
```
sinfo
```
Or, only the nodes where we have priority, blanca-ics nodes
```
sinfo | grep blanca-ics 
```

Looking Good! Next lets play around with different methods to submit a job 
...we are going to use a simple test script 

```
nano test_script.sh
> #!/bin/bash
> #
> # example script
> # 
> echo "sleeping 1 minute..."
> sleep 1m
> echo "Hello World"
[^O^X] # to save and exit

# make sure the script is executable
chmod u+x test_script.sh
```
Lets run our simple test script on HPC compute nodes
Interactively:
```
# lets start an interactive session on a HPC compute node and run our test script
sinteractive --qos=blanca-ics --partition=blanca-ics --account=blanca-ics-training --cpus-per-task=1 --export=NONE
```
You should see a change in prefix on your terminal to indicate you are now running on a compute node [bnodeXXXX]
```
# ...lets run our test script
. test_script.sh
```

Looks good! lets return to the headnode (or login node)
`exit`

Next we will run the same test script from sbatch, we can again use very similar flags

```
mkdir logs    # make a new directory of the output logs

sbatch  --qos=blanca-ics --partition=blanca-ics \
        --account=blanca-ics-test --cpus-per-task=1 \
        --job-name=hpc_tutorial_test  --error=logs/hcp_tutorial.e%j --out=logs/hcp_tutorial.o%j \
        test_script.sh
```

Lets watch for it to finish in the queue
`squeue --qos=blanca-ics | grep $USER`

once it finishes, lets check what the logs say...
```
for i in `ls logs`; do echo $i; cat logs/$i; done
```

## Submitting Jobs in Parallel
I think we have a hang of the basics... lets look at how we run more than one computation at once. 

`cd exercise; mkdir logs`

### Job Array
Compute jobs can be submitted as a job array by adding the `--array` flag in your list of options. Array jobs are great to use to control how many jobs can run in parallel if there are many jobs that need to be run from a list. Each iteration of the job is indicated by a environment variable `SLURM_ARRAY_TASK_ID`. We need to get a little creative sometimes if the jobs we are running are not sequentially ordered as this variable might suggest. Check out the below example to see how we can use a job array to create file from a list of names.
```
cat job_array.sh

# lets try it...
sbatch job_array.sh
```

### Calling the Same Script Many Times
Alternatively, if you want a bit more precise control, or you cannot convert your compute script to fit the profile for a job array, you can simply launch the jobs from a look. One way to constrain the number of jobs you run in parallel is to limit what compute nodes you wish to use or exclude. Lets see an example here.
```
cat job_single.sh

while read line; do sbatch job_single.sh $line; done < word_list.txt
```

## Understanding CPU and Memory Usage
Critically important for large computations is to estimate the required resources, and allocate those resources appropriately. Using high performance computing, we have the option to run job computations that require massive amounts of resources not available on a local computer. These resources are (unfortunately) not unlimited, and therefore we should be mindful when setting up each computation to ensure efficient allocation of resources. 

There are many ways to estimate resources required for your job, and you can perform your own research on this subject starting here. For our purposes, we will discuss only two key steps in job sizing. 
Check what capabilities exist for your underlying software or tool (multi-core processing?). 
Test your job either with a small representative sample, or in short segments of the larger analysis design. 

After testing your job, how can you tell how many CPUs (or cores) and how much memory is right for your full analysis? Measure it! Unfortunately, in most cases the best way to figure out how much memory and CPU load is required, you need to just test the job and check how many resources were used. 

In Blanca, we can easily check how much active cput time (UserCPU) was used and the maximum amount of memory required (MaxRSS) using the sacct command. You may choose to use a common tool developed for INC to check your job performance by loading the SLURM_TOOOLS module provided by ICS. 
```
module use /projects/ics/modules
module load SLURM_TOOLS/0.0.1
```

Now lets look at how many resources were used during a recent freesurfer job (running recon-all). We need to know the job-id to check these job statistics. 
```
jobstats -j 11859032
```

If you are interested in looking at the job statistics from recently completed jobs, here is a list of quearied job-ids below:
> Human Connectome Pipeline Minimal Preprocessing: 12132032_1   
> fMRIPrep: 11507885    
> FSL Diffusion Toolbox: 12093654_24   

## Best Practices for Blanca-ICS Compute

We are excited to support all INC members in utilizing the ICS services including blanca-ics compute and petalibrary storage. We are always available to answer any questions, but you as the user will be the one making many decisions about when and how to use these resources. 

Here are a few rules of thumb to keep in mind:
1. Any large compute job (matlab, python, etc) SHOULD NOT be run on the login nodes (blogin-ics2, blogin01). If you are not sure how to run your computation on the compute nodes, please ask!
2. Be fair about the use of blanca-ics (our priority nodes). These resources are shared among many users so please do not overwhelm the queue for days at a time.
 **Rule of Thumb** Users should allocate no more than 30% (or 128 CPUs) of the available resources at any time (exceptions are  short <2 hour jobs)
3. Consider running your job on other queues (blanca-ccn, blanca-ibg) if there are no resources available on blanca-ics.
4. If you need to reserve large amounts of resources for a quickly approaching deadline, please let [Lena Sherbakov](lena.sherbakov@colorado.edu) or [Amy Hegarty](amy.hegarty@colorado.edu) know to help facilitate resource sharing.

## Computation Jobs With Other Softwares

Many of the examples here are written with the use of bash scripting. This is only one example of how you can run computations of HPC cluster. You will use similar syntax, and the same #SBATCH flags if you want to use python or any other scripting language. One other amazing resource to consider is CURC jupyterhub. Jupyterhub is an interactive jupyter notebook that is run on the summit or blanca computing core and has petalibary mounted. You may generate bash, python or R scripts that can be run interactively in your jupyter notebooks. For more information go to research computing documentation here. 

## Questions ??? 
If you have any questions, please feel free to reach out to Lena Sherbakov (Lena.Sherbakov@colorado.edu) or Amy Hegarty (Amy.Hegarty@colorado.edu). 




