# Tutorial: Amazon Web Services for Large Dataset Processing

This is an interactive tutorial for the use of Amazon Web Services command line interface. In this tutorial we will locate and locally store a subset of neuroimaging files from the Human Connectome Project using Amazon S3 Public Access. All computations will be run using University of Coloraodo at Boulder Reserach Computing compute cluster. If you do not have access to CURC please follow the steps [here](https://rcamp.rc.colorado.edu/accounts/account-request/create/organization) to get started.

If you have not already completed the training on using [Large Datasets on Summit](https://github.com/intermountainneuroimaging/Training/tree/main/Neuroimaging%20Boot%20Camp/2_HPC:%20Large%20Datasets%20on%20Summit#interacting-with-public-datasets-best-practices), please go back and do that first. 

**Learning Objectives:**
- Use Amazon Web Services Command Line tools to explore open-access datasets
- Retrieve key information about the public dataset
- Use aws to store a local copy of public data for analysis

Using a command line tool to retrieve open-access data allows the user to store only the input data needed for current computations, and to remove those data when the local analysis is complete. This can significantly cut down on the static space needed to store these publically accessible datasets. 

## Accessing Human Connectome Project Neuroimaging Data
Before we get started, each user will need to generate an account on the human connectome project website, agree to the data license terms, and generate a amazon web services key.
1. Navigate to https://db.humanconnectome.org/
2. Create a free user account
3. Locate the section: WU-Minn HCP Data - 1200 Subjects
4. Click on data use terms and follow the instructiosns
5. Open the Amazon S3 Access Window, and record both the access Key and Secret Key for use later.

![database screen for human connectome project page](pics/human-connectome-project-img1.png)

*Enter your access key information below:*


```bash
export AWS_ACCESS_KEY_ID=<key-id>              
export AWS_SECRET_ACCESS_KEY=<secret-key-id>    
export AWS_DEFAULT_REGION=us-west-2
```

### Summit Scratch Datasets Filesystem
For this tutorial, we will store a local copy of the human connectome project data on the large scratch drive availible from research computing. If you would like more information about **Summit Scratch Datasets Filesystem** please refer to our previous training module [here](https://github.com/intermountainneuroimaging/Training/tree/main/Neuroimaging%20Boot%20Camp/2_HPC:%20Large%20Datasets%20on%20Summit#summit-scratch-file-system). 

Some key features to remember about Summit Scratch:
1. Summit scratch can only be accessed from a Summit compile or compute node
2. Summit scratch is intended to store large 'scratch' files, so there is no internal backups
3. Summit scratch datasets is a community allocation so correctly setting linux access permissions is critical!


```bash
export SCRATCH_DIR=/gpfs/summit/datasets/ICS

# create a HCP dataset directory if one does not exist
mkdir -p $SCRATCH_DIR/HCP

# set directory group permissions correctly
chgrp hcpgrp $SCRATCH_DIR/HCP

# check that you have access to hcp group
groups $USER
```

### Access Human Connectome Public Dataset on AWS S3 server
Now that we have all necessary creidentials to work with the human connectome dataset, we can use aws command line utilitles reivew all availible data and to download and manipulate files of interest. First, lets add aws command line tools to our path and check whether it is installed correctly.


```bash
module use /projects/ics/modules
module load aws
aws --version
```


Next lets use aws S3 servers to locate and select files from the human connectome project.


```bash
# list the first 10 subjects stored in hcp dataset
aws s3 ls s3://hcp-openaccess/HCP/ | head -n 10
```


```bash
# List all the unprocessed images for an example subject
aws s3 ls s3://hcp-openaccess/HCP/100307/unprocessed/3T/
```

### **Q1:** How many subjects are stored in the HCP open access dataset? Enter your code below.
*Hint:* use `wc -l` 


```bash



```

### **Q2:** What processed files are sorted in the HCP open access dataset? Enter your code below.
*Hint:* Preprocessed subject data is located in `MNINonLinear` directory


```bash



```

### **Q3:** Search for other [open access](https://aws.amazon.com/opendata) datasets you may be insterested in exploring from aws s3. Point to a different dataset and explore the exisiting data files.  Enter your code below.


```bash



```

## Computational Analysis using Human Connectome Dataset
We can use the human connectome public dataset for any computations run on the CU cluster (Blanca, Summit). To do this, first we download a local copy of the input data from hcp-openaccess. We will download these data to a scratch directory as we do not need to retain these images in perpetuity. 


```bash
subj=100307   # subject_id_of_interest

# remember if you want to only work with part of the dataset, 
#    you can indicate that by altering these prospective paths
mkdir -p $SCRATCH_DIR/HCP/${subj}/unprocessed/3T/T1w_MPR1
aws s3 cp s3://hcp-openaccess/HCP/${subj}/unprocessed/3T/T1w_MPR1 \
               $SCRATCH_DIR/HCP/${subj}/unprocessed/3T/T1w_MPR1 --recursive --quiet 

ls -l $SCRATCH_DIR/HCP/${subj}/*/*/*
```


```bash
## add sync command to ignore existing commands (test this functionality)
```

An additional step you may choose to take is to convert the human connectome uprocessed (raw) images to BIDS compatible format. This allow you to use pipelines dedicated to preprocessing BIDS datasets such as `MRIQC` or `fMRIPrep`


```bash
cd $SCRATCH_DIR/
mkdir -p $SCRATCH_DIR/HCP_BIDS

module load python/3.6.5

# download hcp2bids tool if not present...
if ! [ -d hcp2bids ]; then git clone https://github.com/niniko1997/hcp2bids.git ; fi
cd hcp2bids/hcp2bids

#convert hcp subjects to bids compatible
python main.py $SCRATCH_DIR/HCP $SCRATCH_DIR/HCP_BIDS --symlink > hcp2bids.log

# note: some bids tools require extra files not created from this function:
#     T1w.json, T2w.json, dataset_description.json, .bidsignore

```


```bash
ls $SCRATCH_DIR/HCP_BIDS
```


```bash
# finally, its important to dump all local files when you are done using them
rm -R $SCRATCH_DIR/HCP
rm -R $SCRATCH_DIR/HCP_BIDS
```

