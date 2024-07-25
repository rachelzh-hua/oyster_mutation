library(adegenet)
library(poppr)
library(vcfR)
library(writexl)

vcf_data <- read.vcfR('all_combine.nomissing.vcf')

genind_data <- vcfR2genind(vcf_data)
nei_dist <- nei.dist(genind_data)
nei_dist_df <- as.data.frame(as.matrix(nei_dist))
nei_dist_df <- cbind(Row_Names = rownames(nei_dist_df), nei_dist_df)


write_xlsx(nei_dist_df, "nei_genetic_distance.xlsx")                                                                                                                  
