# Tutorial: DataLad for Large Dataset Access and Storage

This is an interactive **bash** tutorial for the use of Datalad in accessing public datasets. [Datalad](https://www.datalad.org/) provides a platform for researchers to share data, document, and track modifications made to their own dataset. In this tutorial we will locate and locally store a subset of neuroimaging files from the Human Connectome Project using Datalad services. Datalad can also be used within python, for more information about datalad's python api click [here](https://docs.datalad.org/en/stable/modref.html). All computations will be run using University of Coloraodo at Boulder Reserach Computing compute cluster. If you do not have access to CURC please follow the steps [here](https://rcamp.rc.colorado.edu/accounts/account-request/create/organization) to get started.

**Learning Objectives:**
- Use Datalad Command Line interface to explore the open-access datasets
- Retrieve key information about the public dataset
- Use datalad to store a local copy of public data for analysis

Using a command line tool to retrieve open-access data allows the user to store only the input data needed for current computations, and to remove those data when the local analysis is complete. This can significantly cut down on the static space needed to store these publically accessible datasets. 

## Accessing Human Connectome Project Neuroimaging Data
Before we get started, each user will need to generate an account on the human connectome project website, agree to the data license terms, and generate an amazon web services key.
1. Navigate to https://db.humanconnectome.org/
2. Create a free user account
3. Locate the section: WU-Minn HCP Data - 1200 Subjects
4. Click on data use terms and follow the instructiosns
5. Open the Amazon S3 Access Window, and record both the access Key and Secret Key for use later.

![database screen for human connectome project page](https://github.com/intermountainneuroimaging/Training/blob/main/Neuroimaging%20Boot%20Camp/3_Public-Datasets-with-AWS/support_images/human-connectome-project-img1.png)

*Enter your access key information below:*


```bash
export DATALAD_hcp_s3_key_id=<key-id>                 
export DATALAD_hcp_s3_secret_id=<secret-key-id>       
```

### Configuring Your Profile for Conda
Before we can access human connectome data via datalad, we first need to ensure datalad can be properly launched for this tutorial. First we will configure your ~/.condarc file. This should not affect any current contents of this file, but we will make a duplicate just in case. For a more general explanation of using conda on Blanca, please visit the Reaserach Computing docs [here](https://curc.readthedocs.io/en/latest/software/python.html).


```bash
# first thing, lets save a backup copy of your current .condarc file (if present)
if [ -f $HOME/.condarc ]; then 
    if ! [ -f $HOME/.condarc_backup ]; then 
        cp $HOME/.condarc $HOME/.condarc_backup;
    fi
fi

# Create .condarc if it doesn't exist
if ! [ -f $HOME/.condarc ]; then 
    touch $HOME/.condarc
    echo "pkgs_dirs:  " > $HOME/.condarc
    echo "  - /projects/$USER/.conda_pkgs" >> $HOME/.condarc
    echo "envs_dirs:" >> $HOME/.condarc
    echo "  - /projects/$USER/software/anaconda/envs" >> $HOME/.condarc
    echo "  - /projects/ics/software/anaconda/envs" >> $HOME/.condarc
fi

# If .condarc exists but path to datalad conda enviornment doesn't exist... add it
if ! grep -Fxq "  - /projects/ics/software/anaconda/envs" $HOME/.condarc; 
then
    # insert path to ics conda enviornment
    sed -i '/envs_dirs:/a\\  - /projects/ics/software/anaconda/envs' $HOME/.condarc ;
fi
```

At the end of this section you should have a conda config file located in your home directory that looks something like this:
```bash
$ more $HOME/.condarc
pkgs_dirs:  
  - /projects/<identikey>/.conda_pkgs
envs_dirs:
  - /projects/<identikey>/software/anaconda/envs
  - /projects/ics/software/anaconda/envs
```
If your file does not look correct, contact the INC data team (Amy Hegarty)[amhe4269@colorado.edu] or (Lena Sherbakov) [lena.sherbakov@colorado.edu]. 


```bash
more $HOME/.condarc
```

Next we will launch Anaconda, which is completed slightly different than other software on Blanca. Here we will simply source the anaconda start script. This will automatically start a "base" conda enviornment. Next we need to change the conda enviornment to our datalad enviornment which already contains all the necessary python packages. An important note here... You will see extra output text in the jupyterhub notebook environemnt as it tries to parse the conda header information (base) or (datalad). This information simply indicates which conda enviornment is active and can be ignored for the purposes of this tutorial.


```bash
# hide the conda prefix on terminal
conda config --set changeps1 False

# LAUNCH ANACONDA
source /curc/sw/anaconda3/latest

# activate datalad conda enviornment (setup on /projects/ics/software)
conda activate datalad

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
mkdir -p $SCRATCH_DIR/human-connectome-project-openaccess/

# set directory group permissions correctly
chgrp hcpgrp $SCRATCH_DIR/human-connectome-project-openaccess/

# check that you have access to hcp group
groups $USER
```

### Access Human Connectome Public Dataset via Datalad url-download
Now that we have all necessary creidentials to work with the human connectome dataset, we can use datalad command line interface to reivew all availible data and to download and manipulate files of interest. First, lets add ensure the AWS credentials were correctly recognized by datalad.


```bash
echo $DATALAD_hcp_s3_key_id
```

Next lets use datalad to navigate files within the human connectome project. An important note, Datalad is setup in a heirarcical way where a dataset can contain multiple sub-datasets. Sub-datasets can in turn also contain additional sub-datasets. Because of the size of the human connectome project data, this dataset is broken into sub-datasets for each subject. This is **not** the default method users should take when building thier own dataset. To learn more about this dataset, please visit [datalad.org](http://handbook.datalad.org/en/latest/usecases/HCP_dataset.html)


```bash
# clone the hcp-open-access dataset (this only retrieves the files paths and no image data)
datalad clone https://github.com/datalad-datasets/human-connectome-project-openaccess.git

echo "Install Complete..."

# list the first 10 subjects stored in hcp dataset
cd human-connectome-project-openaccess 
ls HCP1200 | head -n 10
```


```bash
# to review the contents of a subject, we first must get the sub-dataset for that subject 
# (remember this is a special case for the hcp dataset)
datalad get -n HCP1200/100307

# The hcp dataset is also organized so that each subject's data modalities are seperated into sub-datasets
# here is how to view the file contents of the unprocessed sub-dataset
datalad get -n HCP1200/100307/unprocessed/3T
ls -1 HCP1200/100307/unprocessed/3T
```

Using the `datalad get` command, we add `-n` to notate we want to *clone* a registered subdataset, but not retrieve data. This keeps the size of the locally stored dataset very small and allows us to download large imaging files only at the time of data analysis.

For a datalad dataset that includes multiple subdatasets (such as human connectome project) we can also include a recursive flag (`-r`) to the get command to pull all subdatasets within the current path. In this example we pull the dataset for subject `100408` and all of the subdatasets including the unprocessed and MNI152 (preprocessed) subdatasets.


```bash
datalad get -n -r HCP1200/100408
```

### **Q1:** How many subjects are stored in the HCP open access dataset? Enter your code below.
*Hint:* use `wc -l` 


```bash




```

### **Q2:** What processed files are sorted in the HCP open access dataset? Enter your code below.
*Hint:* Preprocessed subject data is located in `MNINonLinear` sub-dataset


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
cd $SCRATCH_DIR/human-connectome-project-openaccess/
datalad get HCP1200/${subj}/unprocessed/3T > download.log      # this may take several minutes!!!

ls $SCRATCH_DIR/human-connectome-project-openaccess/HCP1200/${subj}/*
```

Data integrity (discussed [here](http://handbook.datalad.org/en/latest/basics/101-115-symlinks.html)) built into datalad's file structure will automatically set all imported data as write protected (or read only access). Before running any computations on these data, we first need to change the read / write permissions for the dataset.


```bash
cd $SCRATCH_DIR
chmod -R u+w human-connectome-project-openaccess/
```

Also, Human Connectome Project dataset User Agreement requires users to restrict access to any data locally downloaded, we need to confirm the new data has the correct user group and permissions.


```bash
# set user and group permissions to read-write and other to none
chmod -R 770 $SCRATCH_DIR/human-connectome-project-openaccess/

# make sure group is set to hcpgrp user group
chgrp -R hcpgrp $SCRATCH_DIR/human-connectome-project-openaccess/

```

An additional step you may choose to take is to convert the human connectome uprocessed (raw) images to BIDS compatible format. This allow you to use pipelines dedicated to preprocessing BIDS datasets such as `MRIQC` or `fMRIPrep`.

Keeping with best practices from our previous tutorial, we will create a results folder first that will be pushed to a permanent storage location, then deleted.


```bash
cd $SCRATCH_DIR

RESULTS_DIR=$SCRATCH_DIR/human-connectome-project-openaccess/results_${USER}

mkdir -p $RESULTS_DIR

module load python/3.6.5

# download hcp2bids tool if not present...
if ! [ -d hcp2bids ]; then git clone https://github.com/niniko1997/hcp2bids.git ; fi
cd hcp2bids/hcp2bids

#convert hcp subjects to bids compatible
HCPdir="$SCRATCH_DIR/human-connectome-project-openaccess/HCP1200"
BIDSdir="$RESULTS_DIR/HCP1200_BIDS"
mkdir -p $BIDSdir

python main.py "$HCPdir" "$BIDSdir" --symlink  > hcp2bids.log

# note: some bids tools require extra files not created from this function:
#     T1w.json, T2w.json, dataset_description.json, .bidsignore

```


```bash
# finally, its important to move all result files to a permanent storage location
mv $RESULTS_DIR /projects/$USER/
```

At the end of your usage of input data, you may choose to remove the locally stored input data. In datalad we can complete this by either using `datalad remove` or `rm -R <directory>`. 


```bash
# OPTIONAL!! remove dataset using datalad command
# --nocheck --nosave --recursive flags used to remove all data and remove any sub-datasets
cd $SCRATCH_DIR/
datalad remove --nocheck --nosave --recursive -d human-connectome-project-openaccess/
```


```bash
# alternative method: dump all local files when you are done using them (make sure all files are write access first)
rm -Rf $SCRATCH_DIR/human-connectome-project-openaccess/
```

This tutorial incompasses only a small fraction of the capabilities of datalad. If you have also worked through the AWS tutorial for public datasets, you will notice working with datalad can be a bit more complex and combersume. The reasoning behind the complexity is that datalad offers additional capacity to version control and providence track all data storage and analysis steps in your workflow. You can store partial datasets and provide a higherarchy of data that allows you to branch multiple analyses from a single central dataset. For more information on datalad, please visit [datalad.org] (http://handbook.datalad.org/en/latest/). Additional tutorials will be added to explore additional datalad functionality for data storage and version control.

