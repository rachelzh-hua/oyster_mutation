rm(list = ls())
setwd('path/to/data')

library(stringr)
library(dplyr)
library(tidyr)

filenames <- list.files(pattern = '*.DP50.het_mut.ann.csv', full.names = TRUE)
all_data <- lapply(filenames, function(x)read.csv(x, header=TRUE, sep=","))
names(all_data) <- gsub('^(.*[/])(.*)(.trio.DP50.het_mut.ann.csv$)','\\2', filenames)

for (i in 1:length(all_data)){
  
  #remove F117 (mom) with any alt read depth
  all_data[[i]]$Oy_F117_AD <- 
    unlist(lapply(strsplit(as.character(all_data[[i]][,12]), 
                                                     ':'), '[[', 2))
  all_data[[i]] <- all_data[[i]]%>%
    separate(Oy_F117_AD, c('Oy_F117_ref', 'Oy_F117_alt'), sep = ',')
  all_data[[i]] <- all_data[[i]]%>%
    filter(!(Oy_F117_ref > 0 & Oy_F117_alt > 0))
  
  
  #CB26 (dad) alt/ref read depth
  all_data[[i]]$Oy_CM26_AD <-
    unlist(lapply(strsplit(as.character(all_data[[i]][,13]), 
                           ':'), '[[', 2))
  all_data[[i]] <- all_data[[i]]%>%
    separate(Oy_CM26_AD, c('Oy_CM26_ref', 'Oy_CM26_alt'), sep = ',')
  all_data[[i]] <- all_data[[i]]%>%
    filter(!(Oy_CM26_ref > 0 & Oy_CM26_alt > 0))
  
  #offspring allelic balance
  all_data[[i]]$Oy_52_AD <-
    unlist(lapply(strsplit(as.character(all_data[[i]][,11]), 
                           ':'), '[[', 2))
  all_data[[i]] <-all_data[[i]]%>%
    separate(Oy_52_AD, c('Oy_52_ref', 'Oy_52_alt'), sep = ',')
  all_data[[i]]$AB <- 
    as.numeric(all_data[[i]]$Oy_52_alt)/(as.numeric(all_data[[i]]$Oy_52_ref)+
                                           as.numeric(all_data[[i]]$Oy_52_alt))
  all_data[[i]] <-all_data[[i]]%>%
    filter(AB >= 0.2 & AB <= 0.8)
}

for (j in seq_along(all_data)){
  write.csv(all_data[[j]], file = paste0(names(all_data)[i], ".trio.het_mut.filter.csv"), 
            row.names = F)
}


