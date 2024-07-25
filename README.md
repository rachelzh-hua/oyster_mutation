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
[GATK3](#gatk)\
vcftools

## Running the pipeline
The entire pipeline is run on bash, R and python.

### 1. Download all [fastq files](https://www.ncbi.nlm.nih.gov/bioproject/566001)
      They are stored in directory [path/to/sequencing_data/fastq_files].
### 2. Download [reference genome](https://www.ncbi.nlm.nih.gov/assembly/GCA_902806645.1)
      They are stored in directory [path/to/sequencing_data/reference].
### 3. Alignment and variant calling.
      bash alignment.sh
      sbatch ${subdir}.sh
The second bash scripts need to be run on SLURM as they can run for upwards to weeks and require memory allocations >8g. 
The maximum run time for SLURM is 168 hours. If necessary, the second scripts can be break up into several parts and run consecutively. 
If more memories are required, see [IndelRealigner_highmem.sh](IndelRealigner_highmem.sh) for example.
### 4. Combine gvcf
	sbatch CombineGVCFs.sh
### 5. Perform joint genotyping on all samples pre-called with HaplotypeCaller
	sbatch GenotypeGVCFs.sh
### 6. Export different parameters 
	zcat combine.all.output.vcf.gz | grep -v '##' |head -40| cut -f8 | grep -o 'QD=[0-9]*\.[0-9]*'
### 7. Show histograms of different parameters 
 	Rscript histogram_parameters.R
### 8. Filter variants based on histograms 
	sbatch VariantFiltration.sh
### 9. Report variants
       zcat combine.all.output_filtered.vcf.gz | grep -v "##" | wc -l
       zcat combine.all.output_filtered.vcf.gz | grep -v "#" |cut -f4 | awk 'length == 1' | wc -l
       zcat combine.all.output_filtered.vcf.gz | grep -v "#" |cut -f4 | awk 'length == 2' | wc -l
       zcat combine.all.output_filtered.vcf.gz | grep -v "#" |cut -f4 | awk 'length > 2' | wc -l
Report number of variants, number of SNPs and other types of variants.
### 10. Quality control on all samples. 
	1. Calculate Nei's genetic distance.
 		Rscript nei_genetic_distance.R
		sbatch nei_R_script.sh
 	2. ADMIXTURE
  		Download ADMIXTURE software
    		/path/to/admixture_linux-1.3.0/admixture
      		
		plink --vcf combine.all.output_filtered.vcf.gz --make-bed --out all_combined.plink --double-id --allow-extra-chr
		(may need to filter out missing data first)
  		> save all output files(.bam/.bed/.fam) in one directory
  		
    		sbatch admixture.sh

  	3. PCA plot
   		plink --bfile all_combined.plink --pca 10 --out all_combine.pca --allow-extra-chr
     		Rscript PCA_plot.R

### 11. Combine trio and variant calling 
	sbatch trio_filter_vcf.sh
### 12. Filter vcf files
      vcftools --vcf ${subdir}.trio.filtered.vcf  --remove-indels  \
      --min-alleles 2 --max-alleles 2 --max-missing 1 --minDP 50 --minQ 30  \
      --recode --stdout | zip -c  > ${subdir}.trio.DP50.vcf
### 13. Convert trio.vcf files into 012 format 
      vcftools --vcf ${subdir}.trio.DP50.recode.vcf --012 --out vcftools --vcf ${subdir}.trio.DP50.recode.vcf --012
### 14. Tabulate non-mutant/het mutant/false progeny mutant
      python find_mutation.py
output tables: \
path/to/${subdir}/${subdir}.DP50_merge.csv \
path/to/${subdir}/${subdir}.DP50_mut.csv \
path/to/${subdir}/${subdir}.DP50_false.csv \
path/to/${subdir}/${subdir}.DP50_het_mut.csv 
### 15. Subset vcf files to only  heterozygous de novo mutation
      python find_pos.py
      vcftools --vcf ${subdir}.trio.DP50.vcf --positions ${subdir}.DP50.info.csv  --recode --stdout  >  ${subdir}.trio.DP50.het_mut.vcf
### 16. Download SnpEff for SNP annotation
See [this](https://github.com/kdews/s-latissima-mutation-annotation/tree/main) for reference. 
### 17. SnpEff build database
	java -jar snpEff.jar build -gtf22 -v cgigas -noCheckCds -noCheckProtein
### 18. SNP annotation
	java -Xmx8g -jar /path/to/snpEff/snpEff.jar cgigas \
 	/path/to/sequencing_data/${subdir}/${subdir}.trio.DP50.het_mut.vcf > /path/to/sequencing_data/${subdir}/${subdir}.trio.DP50.het_mut.ann.vcf
### 19. Find types of SNPs in annotation files
	grep -c HIGH ${subdir}.trio.DP50.het_mut.ann.vcf
 	grep -c missense_variant ${subdir}.trio.DP50.het_mut.ann.vcf
  	grep -c synonymous_variant ${subdir}.trio.DP50.het_mut.ann.vcf
### 20. Additional filter 
	Rscript additional_filter.R
 




      
## <a name="gatk">GATK</a>
GATK4 has changed the workflow of variant calling using the new version of [HaplotypeCaller](https://github.com/broadinstitute/gatk-docs/blob/master/blog-2012-to-2019/2016-06-21-Changing_workflows_around_calling_SNPs_and_indels.md?id=7847). Indel realignment using RealignerTargetCreator and IndelRealigner has since been omitted from GATK4. 
For the purpose of this project, we performed indel realignment before base quality score recalibration (BQSR) and after duplicate marking using GATK3.
Older versions of GATK and documents can be found [here](https://github.com/broadinstitute/gatk-docs).
The version we used in this project is GenomeAnalysisTK-3.8-1-0-gf15c1c3ef. Java version 1.8.x is required to run this version of GATK.



