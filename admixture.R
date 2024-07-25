library(ggplot2)
library(tidyr)

q_matrix <- read.table("all_combine.nomissing.7.Q", header=FALSE)
colnames(q_matrix) <- paste0("K", 1:ncol(q_matrix))

q_matrix$ID <- c('Oy_39_A','Oy_39_C','Oy_39_D','Oy_39_G',
                 'Oy_40_A', 'Oy_40_B','Oy_40_C','Oy_40_G',
                 'Oy_51_A', 'Oy_51_B','Oy_51_F',
                 'Oy_52_A','Oy_52_B','Oy_52_C','Oy_52_G',
                 'Oy_F100', 'Oy_F101', 'Oy_F117', 'Oy_F116',
                 'Oy_M20', 'Oy_M_CB26')
q_matrix$order <- c(1:21)
new_order <- c(16,1,2,3,4,20,5,6,7,8,17,19,9,10,11,21,12,13,14,15,18)

q_matrix <- q_matrix[new_order,]
q_matrix <- q_matrix [,-9]
row.names(q_matrix) <- NULL

q_long <- gather(q_matrix, key="K", value="Proportion", -ID)
q_long$ID <- factor(q_long$ID, levels = unique(q_long$ID))

ggplot(q_long, aes(x = ID, y = Proportion, fill = K)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "ADMIXTURE", 
       x = "Individuals") 
