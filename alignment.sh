DATADIR='/project/noujdine_61/rachelh/oyster/sequencing_data/fastq_files'
REF='/project/noujdine_61/rachelh/oyster/sequencing_data/reference/GCA_902806645.1.fasta'

DATAOUT='/project/noujdine_61/rachelh/oyster/sequencing_data/bwa_output_files'
mkdir $DATAOUT

for f in  $DATADIR/*.1.fastq.gz; do
	subdir=$(basename "$f" |cut -d '.' -f 1,2)
	
	
	cat <<-EoF > ./${subdir}.sh
	#!/bin/bash
	
	#SBATCH --account=noujdine_61
	#SBATCH --partition=oneweek
	#SBATCH --nodes=1
	#SBATCH --ntasks=1
	#SBATCH --cpus-per-task=8
	#SBATCH --mem=32G
	#SBATCH --time=168:00:00
	
	module purge
	eval "\$(conda shell.bash hook)"
	conda activate /project/noujdine_61/rachelh/env/gatk4
	
	module load gcc/8.3.0
	module load openjdk/1.8.0_202-b08 
	module load samtools
	module load bwa
	module load picard
	
	DATADIR='/project/noujdine_61/rachelh/oyster/sequencing_data/fastq_files'
	REF='/project/noujdine_61/rachelh/oyster/sequencing_data/reference/GCA_902806645.1.fasta'
	
	DATAOUT='/project/noujdine_61/rachelh/oyster/sequencing_data/output_files'
	mkdir -p $DATAOUT/$subdir
	
	bwa aln -t 12 -R 8 $REF $DATADIR/${subdir}.1.fastq.gz > $DATAOUT/$subdir/${subdir}.1.sai
	bwa aln -t 12 -R 8 $REF $DATADIR/${subdir}.2.fastq.gz > $DATAOUT/$subdir/${subdir}.2.sai
	
	bwa sampe -r '@RG\tID:${subdir}\tSM:$(basename $subdir | cut -d '.' -f 1)\tLB:${subdir}\tPL:Illumina' $REF    $DATAOUT/$subdir/${subdir}.1.sai  $DATAOUT/$subdir/${subdir}.2.sai $DATADIR/${subdir}.1.fastq.gz $DATADIR/${subdir}.2.fastq.gz | \
	samtools view -bSh - | \
	samtools sort -o  $DATAOUT/$subdir/${subdir}_alignment_bwa.sort.bam
	
	picard MarkDuplicates -I $DATAOUT/$subdir/${subdir}_alignment_bwa.sort.bam -O $DATAOUT/$subdir/${subdir}_alignment.marked_duplicates.bam -M  $DATAOUT/$subdir/${subdir}_marked_dup_metrics.txt --REMOVE_DUPLICATES true --VALIDATION_STRINGENCY LENIENT 

	java -jar /project/noujdine_61/rachelh/env/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef/GenomeAnalysisTK.jar \
    -T RealignerTargetCreator \
    -R  $REF  \
    -I  $DATAOUT/$subdir/${subdir}_alignment.marked_duplicates.bam \
	    -o  $DATAOUT/$subdir/${subdir}_realignertargetcreator.intervals

	java -jar /project/noujdine_61/rachelh/env/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef/GenomeAnalysisTK.jar   -T IndelRealigner -R  $REF -targetIntervals $DATAOUT/$subdir/{subdir}_realignertargetcreator.intervals -I   $DATAOUT/$subdir/${subdir}_alignment_bwa.sort.bam -o  $DATAOUT/$subdir/${subdir}_indelrealigner.bam
	
	picard  FixMateInformation I= $DATAOUT/$subdir/${subdir}_test.indelrealigner.bam O=$DATAOUT/$subdir/${subdir}_fixed_mate.bam VALIDATION_STRINGENCY=SILENT 

	samtools index $DATAOUT/$subdir/${subdir}_test.fixed_mate.bam
	
	gatk --java-options "-Xmx20g"   HaplotypeCaller  -R $REF -I  $DATAOUT/$subdir/${subdir}_test.fixed_mate.bam -O  $DATAOUT/$subdir/${subdir}.g.vcf.gz -ERC GVCF
	
	EoF
done
