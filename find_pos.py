import os
os.environ['OPENBLAS_NUM_THREADS'] = '1'
import pandas as pd
df = pd.read_csv('{subdir}.DP50_het_mut.csv')
df = df.loc[:,['CHROM','POS']] 
df.to_csv(r'{subdir}.DP50.info.csv', index=False, sep='\t')

