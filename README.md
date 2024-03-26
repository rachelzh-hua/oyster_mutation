# De novo mutation rate in Pacific oysters _Crassostrea gigas_
A pipeline to detect and calculate de novo mutations in trios of Pacific oysters. 

## Dependencies 
bash shell (default on many machines) \
R \
python \
java \
sratoolkit \
samtools \
bwa \
picard \
GATK4 \
[GATK3](#gatk)

## Running the pipeline
### 1. Download all [fastq files](https://www.ncbi.nlm.nih.gov/bioproject/566001)
      They are stored in directory [path/to/sequencing_data/fastq].
### 2. Download [reference genome](https://www.ncbi.nlm.nih.gov/assembly/GCA_902806645.1)
      They are stored in directory [path/to/sequencing_data/reference].

      
## <a name="gatk">GATK</a>

GATK4 has changed the workflow of variant calling using the new version of [HaplotypeCaller](https://github.com/broadinstitute/gatk-docs/blob/master/blog-2012-to-2019/2016-06-21-Changing_workflows_around_calling_SNPs_and_indels.md?id=7847). Indel realignment using RealignerTargetCreator and IndelRealigner has since been omitted from GATK4. 
For the purpose of this project, we performed indel realignment before base quality score recalibration (BQSR) and after duplicate marking using GATK3.
Older versions of GATK and documents can be found [here](https://github.com/broadinstitute/gatk-docs).
The version we used in this project is GenomeAnalysisTK-3.8-1-0-gf15c1c3ef. Java version 1.8.x is required to run this version of GATK.



