#!/bin/bash

#SBATCH --account={account_name}
#SBATCH --partition=main
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=48:00:00

module purge
eval "$(conda shell.bash hook)"
conda activate /path/to/env/gatk4

REF='/path/to/reference/GCA_902806645.1.fasta'
DATAOUT='path/to/sequencing_data/bwa_output_files'

gatk CombineGVCFs \
-R $REF \
-V $DATAOUT/${subdir1}/${subdir1}.g.vcf.gz \
-V $DATAOUT/${subdir...}/${subdir...}.g.v \
...
-V $DATAOUT/${subdir...}/${subdir...}.g.vcf.gz \cf.gz \
-V $DATAOUT/${subdir_n}/${subdir_n}.g.vcf.gz \
-O $DATAOUT/combine.trio.g.vcf.gz

