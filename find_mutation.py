import os
os.environ['OPENBLAS_NUM_THREADS'] = '1'
import pandas as pd
import io
import numpy as np
import gzip

def read_vcf(path):
        with open(path, 'r')as f:
                lines=[l for l in f if not l.startswith('##')]
        return pd.read_csv(
                io.StringIO(''.join(lines)),
                dtype={'#CHROM':str,'POS':int,'ID':str,'REF':str,'ALT':str,'QUAL':str,'FILTER':str,'INFO':str},
                sep='\t'
        ).rename(columns={'#CHROM':'CHROM'})

{subdir}=read_vcf('{subdir}.trio.DP30.vcf')

{subdir}_pos = pd.read_csv('{subdir}.trio.012.pos', sep='\t', header=None)
{subdir}_pos.index += 1
{subdir}_pos.columns=['CHROM','POS']

{subdir}_012 = pd.read_csv('{subdir}.012',  header=None, sep='\t')
{subdir}_012 = {subdir}_012.transpose()
{subdir}_012.columns=['{subdir}_012', '{subdir}_012','{subdir}_012']

{subdir}_info = pd.concat([{subdir}_pos,{subdir}_012], axis =1 )

{subdir}_merge= pd.merge({subdir}, {subdir}_info, how='inner', on =['CHROM', 'POS'])

{subdir}_merge= {subdir}_merge.loc[({subdir}_merge['{subdir}_012']!= -1) &
        ({subdir}_merge['Oy_F117_012']!= -1) &
        ({subdir}_merge['Oy_M_CB26_012']!= -1)]

{subdir}_merge['combine'] = {subdir}_merge[{subdir}_merge.columns[12:]].apply(
        lambda x: ''.join(x.astype(str)),
        axis=1
        )

{subdir}_mut = {subdir}_merge.loc[{subdir}_merge['combine'].isin(
        ['100','122','202','002','020','012','021','201','210','220','201'])]

{subdir}_het_mut = {subdir}_merge.loc[{subdir}_merge['combine'].isin(
        ['100', '122'])]

{subdir}_wt ={subdir}_merge.loc[{subdir}_merge['combine'].isin(
        [ '010', '001', '011', '101', '212', '102', '111', '110','112','221', '211', '121', '000', '222'])]

{subdir}_false = {subdir}_merge.loc[{subdir}_merge['combine'].isin(
        [ '200','022'])]

DATAOUT='/project/noujdine_61/rachelh/oyster/sequencing_data/trio_files/{subdir}.trio'

{subdir}_merge.to_csv(r'$DATAOUT/{subdir}.DP50_merge.csv')
{subdir}_mut.to_csv(r'$DATAOTUT/{subdir}.DP50_mut.csv')
{subdir}_false.to_csv(r'$DATAOUT/{subdir}.DP50_false.csv')
{subdir}_het_mut.to_csv(r'$DATAOUT/{subdir}.DP50_het_mut.csv')

