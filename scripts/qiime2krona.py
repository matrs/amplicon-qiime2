#! /usr/bin/env/python

def load_artifact(artifact):
    '''It takes a qiime2 artifact and create a pandas dataframe from it'''
    
    import pandas as pd
    from qiime2 import Artifact
    
    artifact = Artifact.load(artifact)
    return artifact.view(pd.DataFrame)

def taxon_cleaning(taxo_art):
    '''It takes a pandas df created from an `feature-classifier` artifact and Silva as db'''
    
    df = load_artifact(taxo_art)
    return df["Taxon"].str.split(";", expand=True).apply(func= lambda x: x.str.replace(r'._{1,2}', ''))

def feature_taxo_merger(taxo_art, feat_art):
    '''Takes two artifacts, one from taxonomic analysis and other from features (dada2 table), and merge them'''
    
    df_taxo = taxon_cleaning(taxo_art)
    df_feat = load_artifact(feat_art).T
    df_merged = df_taxo.merge(df_feat, how='inner', left_index=True, right_index=True, indicator="Merge_info")
    
    assert sum(df_merged["Merge_info"] == 'both') == df_merged.shape[0]
    df_merged['Feat_ID'] = df_merged.index
    df_merged.reset_index(drop=True, inplace=True)
    return (df_merged, df_feat.columns.to_list())

def kronatext_writer(taxo_art, feat_art, path='.'):
    '''
    Takes two artifacts, one from taxonomic classification and other from features 
    (dada2/deblur table) and writes one archive per sample. Written archives are named by 
    their respective samples' name. `path` is the directory path where files will be written. 
    '''
    
    from pathlib import Path
    import os
    
    merged_df, feat_cols = feature_taxo_merger(taxo_art, feat_art)
    tax_cols = list(range(0,7))
    path = Path(path)
    os.makedirs(path, exist_ok=True)
    for sample_name in feat_cols:
        f_name = '{}.tsv'.format(sample_name)
        f_path = path.joinpath(f_name)
        cols_to_write = [sample_name] + tax_cols + ["Feat_ID"] #'Feat_ID' has to be the last column
        df_to_write = merged_df.loc[: , cols_to_write].to_csv(f_path, sep="\t", header=False, index=False)

def arg_parser(args):
    
    import argparse

    parser = argparse.ArgumentParser(prog='Qiime2Krona', description='Creates tsv files compaible with ktImportText')
    parser.add_argument('taxo_art', type=str, help="QIIME2 artifact coming from a taxonomic analysis using Silva")
    parser.add_argument('feat_art', type=str, help="QIIME2 'feature table' artifact comming from denoising (DADA2 or other)")
    parser.add_argument('path', type=str,  help="Directory path where files will be written")
    args = parser.parse_args()
    
    return args

def main(args=None):
    args = arg_parser(args)
    #print(args)
    kronatext_writer(args.taxo_art, args.feat_art, args.path)

if __name__ == '__main__':
    main()
