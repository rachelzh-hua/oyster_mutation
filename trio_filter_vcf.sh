#!/bin/bash

#SBATCH --account={account_name}
#SBATCH --partition=oneweek
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=168:00:00

module purge
eval "$(conda shell.bash hook)"
conda activate /path/to/env/gatk4

REF='/path/to/reference/ref.fasta'
DATAOUT='path/to/sequencing_data/trio_files'
mkdir $DATAOUT

cd $DATAOUT

gatk CombineGVCFs \
-R $REF \
-V $DATAOUT/${subdir1}/${subdir1}.g.vcf.gz \
-V $DATAOUT/${subdir_f}/${subdir_f}.g.v \
-V $DATAOUT/${subdir_m}/${subdir_m}.g.vcf.gz \
-O $DATAOUT/${subdir1}.trio.g.vcf.gz

gatk --java-options "-Xmx20g" GenotypeGVCFs \
   -R $REF \
   -V $DATAOUT/${subdir1}.trio.g.vcf.gz \
   -O $DATAOUT/${subdir1}.trio.vcf.gz

gatk --java-options "-Xmx20g" VariantFiltration \
	    -V $DATAOUT/${subdir1}.trio.vcf.gz\
	    -filter "QD < 2.0" --filter-name "QD2" \
	    -filter "FS < 20.0" --filter-name "FS20" \
	    -filter "MQ > 50.0" --filter-name "MQ50" \
	    -filter "SOR>4.0" --filter-name "SOR4" \
	    -filter "MQRankSum < 8.0" --filter-name "MQRankSum-8" \
	    -filter "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8" \
	    -O $DATAOUT/${subdir1}.trio.filtered.vcf
