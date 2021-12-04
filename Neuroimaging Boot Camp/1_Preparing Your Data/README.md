# Preparing Your Research Data For Storage and Analysis

# -------------------------
# UNDER DEVELOPMENT
# -------------------------

In this workshop, we will discuss best practices to store your reserach data in a secure, easily searchable, manner. Consistency in directory structure, naming convention, and version control scripts can all increase the efficency and effectiveness of your research studies. 

Learning Objectives:
 - Use Brain Imaging Data Strucutre (BIDS) naming conventions
 - Create organized directory structures for data storage and analysis
 - ...

## 1. How to develop transparent and reproducible analysis methods?
Are most published research findings false?... Recent studies ***suggests 60% of studies are not reproducible*** (Nichols, 2017), 42% of studies lack quantitative replication (Hong, 2019)
 - Lack of detail required to reproduce methods used in publication
 - Issues in version control of internal analysis methods
We can ***combat these issues*** with tools available to us today!!
 - ***Version control*** software for “custom” analysis code (e.g. Github)
 - Publicly shared analysis “workflows” called <u>***containers***</u> (e.g. Singularity)
 - ***Common data structure*** (e.g. BIDS)

### 1.1 What is the Brain Imaging Data Structure (BIDS) Naming Convention
BIDS is a naming convention standard first initiated during an INCF sponsered data sharing working group meeting at Standford Univeristy. The standard has been spearheaded by Chris Gorgolewski and the Poldrack Lab at Standford University in the Center for Reproducible Neuroscience. 
> "Neuroimaging experiments result in complicated data that can be arranged in many different ways. So far there is no consensus how to organize and share data obtained in neuroimaging experiments. Even two researchers working in the same lab can opt to arrange their data in a different way. Lack of consensus (or a standard) leads to ***misunderstandings*** and ***time wasted*** on rearranging data or rewriting scripts expecting certain structure. With the Brain Imaging Data Structure (BIDS), we describe a simple and easy to adopt way of organizing neuroimaging and behavioral data."<br> <div style="text-align: right"> --*BIDS Documentation* </div>

### 1.2 So Why Does BIDS Matter? 
BIDS naming convention for neuroimaging data has quickly risen to the most adopted format for storing and curating raw and derived neuroimaging data. If you are looking to upload or download data from a number of common data repositories such as: OpenNeuro, SchizConnect, Developing Human Connectome Project, and FCP-INDI; you will be using BIDS naming convention. 

There are a number of tools readily availible to help researchers convert their newly scanned or archived data to a BIDS format. The Intermountain Neuroimaging Consortium tool can be found [here](https://github.com/intermountainneuroimaging/dcm2bids.git), among others for converting from the Human Connectome Project data [here](https://github.com/suyashdb/hcp2bids), and many others.

BIDS naming convention is a community sponsored project and is therefore always growing, adapting and changing. To stay up on the most recent BIDS format, visit their documentation [here](https://bids.neuroimaging.io/). In the following document, we will review some of the most relevant pieces of the BIDS naming convention.

## 2. BIDS Specification
Here we will review only a few key parts of the BIDS specification. Please visit their documentation [online](https://bids-specification.readthedocs.io/en/stable/) for a full description. 

### 2.0 The Basics...
A file name consists of a chain of *entities*, or key-value pairs, a *suffix* and an *extension*. Two prominent examples of entities are <code>subject</code> and <code>session</code>.

For a data file that was collected in a given <code>session</code> from a given
<code>subject</code>, the file name MUST begin with the string <code>sub-&lt;label&gt;_ses-&lt;label&gt;</code>. If all sessions are single event, meaning all participants will have only one session, you can optionally begin a file name with the string <code>sub-&lt;label&gt;</code> and omit the session key.

Each entity that is associated with a given file is linked together using an underscore between each <code>key-&lt;value&gt;</code> pairs. For example, <code>sub-01_task-rest_eeg.edf</code>, is a file that contains resting state eeg data in the format <code>.edf</code> from subject `01`.

#### 2.0.1 Example Organization
Putting this all together, first we want to organize the raw data by subject (and session if necessary). Each data file is labeled by subject, and any other *entities* or <code>key-&lt;value&gt;</code> descriptors critical to the interpretation of the file's information. 
```
sub-01/
    anat/
        sub-01_T1w.nii.gz
    func/
        sub-01_task-nback_acq-test1_run-1_bold.nii.gz
        sub-01_task-nback_acq-test1_run-2_bold.nii.gz
        sub-01_task-nback_acq-test1_bold.json
```


### 2.1 BIDS Format Entities

Here we will discuss possible entities, or key-value pairs that could be included in the naming convention for different aquisition types. This is not an exahstive list, and please consult the BIDS [documentation](https://bids-specification.readthedocs.io/en/stable/99-appendices/04-entity-table.html) for more info.

| Image type | Entity | Subject | Session | Task | Acquisition | Reconstruction | Phase-Encoding Direction | Run |
| ----------- | ----------- | ----------- | ----------- | ----------- | ----------- | ----------- | ----------- | ----------- |
| **Format** | `suffix` | `sub-<label>` | `ses-<label>` | `task-<label>` | `acq-<label>` | `rec-<label>` | `dir-<label>` | `run-<index>` |
| **anat** | T1w | REQUIRED | OPTIONAL | | OPTIONAL | OPTIONAL | | OPTIONAL |
| **anat** | T2w | REQUIRED | OPTIONAL | | OPTIONAL | OPTIONAL | | OPTIONAL |
| **dwi** | dwi | REQUIRED | OPTIONAL | | OPTIONAL | | OPTIONAL | OPTIONAL |
| **dwi** | sbref | REQUIRED | OPTIONAL | | OPTIONAL | | OPTIONAL | OPTIONAL |
| **fmap** | phasediff | REQUIRED | OPTIONAL | | OPTIONAL | | | OPTIONAL |
| **fmap** | fieldmap | REQUIRED | OPTIONAL | | OPTIONAL | | | OPTIONAL |
| **func** | bold | REQUIRED | OPTIONAL | OPTIONAL | OPTIONAL | OPTIONAL | OPTIONAL | OPTIONAL |
| **func** | sbref | REQUIRED | OPTIONAL | OPTIONAL | OPTIONAL | OPTIONAL | OPTIONAL | OPTIONAL |
| **func** | cbv | REQUIRED | OPTIONAL | OPTIONAL | OPTIONAL | OPTIONAL | OPTIONAL | OPTIONAL |
| **func** | events | REQUIRED | OPTIONAL | OPTIONAL | OPTIONAL | OPTIONAL | OPTIONAL | OPTIONAL |
| **func** | physio stim | REQUIRED | OPTIONAL | OPTIONAL | OPTIONAL | OPTIONAL | OPTIONAL | OPTIONAL |

### 2.2 Putting It All Together
Here is what a BIDS format file looks like put together:

#### 2.2.1 Anatomy imaging data template
```
sub-<label>/[ses-<label>/]
    anat/
        sub-<label>[_ses-<label>][_acq-<label>][_ce-<label>][_rec-<label>][_run-<index>][_echo-<index>][_flip-<index>][_inv-<index>][_mt-<label>][_part-<label>]_<suffix>.nii[.gz]
```

#### 2.2.2 Fieldmap data
```
sub-<label>/[ses-<label>/]
    fmap/
        sub-<label>[_ses-<label>][_acq-<label>][_ce-<label>][_rec-<label>][_run-<index>][_echo-<index>][_flip-<index>][_inv-<index>][_mt-<label>][_part-<label>]_<suffix>.nii[.gz]
```

#### 2.2.3 Functional imaging data
```
sub-<label>/[ses-<label>/]
    fmap/
        sub-<label>[_ses-<label>][_task-<label>][_acq-<label>][_ce-<label>][_rec-<label>][_run-<index>][_echo-<index>][_part-<label>]_<suffix>.nii[.gz]
```

### 2.3 Source and Derivative Data
While the BIDS format was not intially developed for *Derivative data*, new versions of the standard to include Derivative file conventions. Most importantly...derivative files MUST be kept separate from the raw data. This way one can protect the raw data from accidental changes by file permissions. Soruce data (or data collected from any measurement tool, i.e. DICOM or E-PRIME files) preferably should be stored with the dataset in a seperate `sourcedata` folder. 

#### 2.3.1 Some Example Organization

This example shows how the source data, raw data, and derivative data can be broken into seperate subdirectories in the same dataset. 
```
my_dataset/
  sourcedata/
    ...
  rawdata/
    dataset_description.json
    participants.tsv
    sub-01/
    sub-02/
    ...
  derivatives/
    pipeline_1/
    pipeline_2/
    ...
```


Alternatively, here is an example organization where the dertivative dataset files are not intended to be published with the source and raw data. In this case, two sub-directories `code` and `sourcedata` are nested within the BIDS raw data directory. 
```
my_processed_data/
  code/
    processing_pipeline-1.0.0.img
    hpc_submitter.sh
    ...
  sourcedata/
    dataset_description.json
    participants.tsv
    sub-01/
    sub-02/
    ...
  dataset_description.json
  sub-01/
  sub-02/
  ...
```

These organizational rules surounding source data and derivative data are simply guidelines. Dependent on your use case, you may choose to seperate the `sourcedata` or `derivative` directories from the more constrained input / raw dataset.

### 2.4 Additional Important Files
In addition to approprately naming and organizing your files, you want to include a few key documents to describe the dataset, participants, and usage. BIDS recommends you include the following files:
 - `dataset_description.json`
 - `README`
 - `CHANGES`
 - `LICENSE`
 
For more information about what information needs to be in each file, and its organization please visit the BIDS documentation [here](https://bids-specification.readthedocs.io/en/stable/03-modality-agnostic-files.html).

### Lets Try It!

**!! COME BACK TO THIS ... lets try to use [heudiconv](https://heudiconv.readthedocs.io/en/latest/tutorials.html)!!**
Follow this [link](https://andysbrainbook.readthedocs.io/en/latest/OpenScience/OS/BIDS_Overview.html?highlight=bids#bids-tutorial) to an awesome tutorial...


```bash
dataset_dir=/gpfs/summit/datasets/ICS/tutorials/myconnectome/
ls $dataset_dir
```

```bash
#use singularity to run heudiconv (BIDS tool for DICOM conversion)
image=/pl/active/ics/containers/heudiconv/heudiconv-v0.9.0.sif
module load singularity
singularity run --bind $dataset_dir:/base $image                     \
  -d /base/dicom/sub-{subject}/ses-{session}/SCANS/*/DICOM/*.dcm     \
  -o /base/Nifti/ -f convertall -s 01 -ss 001 -c none --overwrite
```

```bash
ls -a $dataset_dir/Nifti/.heudiconv/01/info

cat $dataset_dir/Nifti/.heudiconv/01/info/dicominfo_ses-001.tsv
```
