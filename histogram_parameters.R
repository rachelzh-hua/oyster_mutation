setwd("path/to/data")

QDtable <- read.csv(file = 'QD_output.txt', header = F, sep='=')
colnames(QDtable)[1] <- 'QD'
colnames(QDtable)[2] <- 'QD_value'
hist(QDtable$QD_value, freq= F, main = 'QD value density', xlab = 'QD value')
lines(density(QDtable$QD_value), col = 2, lwd =2)

FStable <- read.csv(file = 'FS_output.txt', header = F, sep='=')
colnames(FStable)[1] <- 'FS'
colnames(FStable)[2] <- 'FS_value'
hist(FStable$FS_value, freq= F, main = 'FS value density', xlab = 'FS value',
     xlim= c(0,100), ylim = c(0,0.08))
lines(density(FStable$FS_value), col = 2, lwd =2)

SORtable <- read.csv(file = 'SOR_output.txt', header = F, sep='=')
colnames(SORtable)[1] <- 'SOR'
colnames(SORtable)[2] <- 'SOR_value'
hist(SORtable$SOR_value, freq= F, main = 'SOR value density', xlab = 'SOR value',
     xlim= c(0,15), ylim = c(0,1))
lines(density(SORtable$SOR_value), col = 2, lwd =2)

MQtable <- read.csv(file = 'MQ_output.txt', header = F, sep='=')
colnames(MQtable)[1] <- 'MQ'
colnames(MQtable)[2] <- 'MQ_value'
hist(MQtable$MQ_value, freq= F, main = 'MQ value density', xlab = 'MQ value', 
     ylim = c(0,0.1))
lines(density(MQtable$MQ_value), col = 2, lwd =2)

MQRankSum <- read.csv(file = 'MQRankSum_output.txt', header = F, sep='=')
colnames(MQRankSum)[1] <- 'MQRankSum'
colnames(MQRankSum)[2] <- 'MQRankSum_value'
hist(MQRankSum$MQRankSum_value, freq= F, main = 'MQRankSum value density', 
     xlab = 'MQRankSum value', xlim = c(-15, 15),
     ylim = c(0,0.4))
lines(density(MQRankSum$MQRankSum_value), col = 2, lwd =2)

ReadPosRankSum <- read.csv(file = 'ReadPosRankSum_output.txt', header = F, sep='=')
colnames(ReadPosRankSum)[1] <- 'ReadPosRankSum'
colnames(ReadPosRankSum)[2] <- 'ReadPosRankSum_value'
hist(ReadPosRankSum$ReadPosRankSum_value, freq= F, main = 'ReadPosRankSum value density', 
     xlab = 'ReadPosRankSum value', xlim = c(-6, 7),
     ylim = c(0,0.7))
lines(density(ReadPosRankSum$ReadPosRankSum_value), col = 2, lwd =2)
