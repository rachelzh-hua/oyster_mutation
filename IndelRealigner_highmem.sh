#!/bin/bash

#SBATCH --account={account_name}
#SBATCH --partition=oneweek
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=60:00:00


module load gcc/8.3.0
module load openjdk/1.8.0_202-b08

export TMPDIR=/path/to/gatk_temp

java -Xmx512M -XX:MaxHeapSize=512m -Djava.io.tmpdir=/path/to/gatk_temp -jar /path/to/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef/GenomeAnalysisTK.jar\
-T IndelRealigner \
-R  /path/to/reference/GCA_902806645.1.fasta \
-targetIntervals /path/to/bwa_output_files/${subdir}/${subdir}_realignertargetcreator.intervals \
-I   /path/to/sequencing_data/bwa_output_files/${subdir}/${subdir}_alignment_bwa.sort.bam \
-o  /path/to/sequencing_data/bwa_output_files/${subdir}/${subdir}0_indelrealigner.bam \
--TMP_DIR /path/to/gatk_temp
