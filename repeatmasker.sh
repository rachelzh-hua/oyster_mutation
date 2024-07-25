#!/bin/bash

#SBATCH --account={account_name}
#SBATCH --partition=main
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=48:00:00

module purge
module load gcc/8.3.0

RepeatMasker -species mollusks /path/to/cleaned_fasta


