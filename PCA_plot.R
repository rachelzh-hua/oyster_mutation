pca_results <- read.table("all_combine.pca.eigenvec", header = F)
colnames(pca_results) <- c("FID", "IID", paste0("PC", 1:10))

pca_plot_data <- pca_results[, c("PC1", "PC2", 'IID')]
ggplot(pca_plot_data, aes(x = PC1, y = PC2)) +
  geom_point() +
  geom_text_repel(aes(label = IID), size = 3, max.overlaps = Inf) +
  theme_minimal() +
  labs(title = "PCA Plot of all samples", 
       x = "Principal Component 1", y = "Principal Component 2")
