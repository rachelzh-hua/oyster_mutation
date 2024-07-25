#!/bin/bash

#SBATCH --account={account_name}
#SBATCH --partition=main
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00

module purge

cd /path/to/plink/output/files/directory

/path/to/admixture all_combine.plink 7
