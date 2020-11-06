#! /usr/bin/env python

#print("type snakemake input", type(snakemake.input),snakemake.input)

def sample_list():
    '''
    Creates a natural-sorted python list
    '''
    from pathlib import Path
    from natsort import natsorted, ns
    path=Path('.').absolute()

    files = [path.joinpath(file) for file in snakemake.input]
    files_sorted = natsorted(files , alg=ns.PATH)
    print("files_sorted", files_sorted)
    return files_sorted


def groups_it(iterable, n):
    '''
    Creates tuples of groups of `n` files each. Takes as input any iterable, here I expect
    a sorted list of files produced by `glob` or similar. The last element of a tuple isn't 
    the first element of the next one.
    '''
    return zip(*[iter(iterable)]*n)


    
with open("samples_qiime.tsv", "w", encoding='utf8') as fh:
    #Here the header may be modified
    print('sample-id', 'forward-absolute-filepath', 'reverse-absolute-filepath', sep='\t', file=fh)
    sorted_files = sample_list()
    #Change the split character for other cases.
    for pair in groups_it(sorted_files, 2):
        print(pair[0].name.split('_')[0], pair[0], pair[1], sep='\t', file = fh)
