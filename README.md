# Amplicon pipeline

This pipeline is based mainly in **QIIME2**, using `dada2` as denoiser and `q2-sepp`
plugin to build a phylogenetic tree. `sepp` implements an algorithm to insert sequences 
into an existing (large) phylogeny (greengenes by default). This pipeline Also implements 
an alternative workflow for reconstructing a *de novo* phylogeny using `mafft` and 
`fasttree`, which is much more light in terms of computing resources than `sepp`. 

For diversity, produces multiple alpha and beta metrics. Furthermore, it produces a 
taxonomy analysis based in a scikit-learn classifier specially trained for the specific
type of amplicon (16S rRNA hyper-variable V4 region), generating interactive bar plots and
a `krona` plot.

For differential abundance analysis, runs "_analysis of composition of microbiomes_",
ANCOM, using its `qiime` plugin.

## Run the first part of the pipeline, needed to select certain parameters used afterwards 

`snakemake -pr --forceall demux_summary -j $Core_Number`

```bash
        count   jobs
        16      cutadapt_pe
        1       demux_summary
        1       make_samples
        1       qiime_import
```

## Run the whole pipeline

`snakemake -pr -j $Core_Number`

