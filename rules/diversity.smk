rule alpha_rare:
    input:
        rules.dada2.output.table
    output:
        "results/qiime/vis/alpha_rarefication.qzv"
    log:
        "logs/qiime_alpha-rare.log"
    params:
        meta="metdata.tsv",
        min_depth=100,
        max_depth=145000
    shell:
        ("qiime diversity alpha-rarefaction --i-table {input} "
        "--m-metadata-file {params.meta} --o-visualization {output} "
        "--p-min-depth  {params.min_depth} --p-max-depth {params.max_depth} &> {log}")
    
    
rule core_metrics:
    input:
        tree=rules.fragment_insertion.output.tree,
        table=rules.dada2.output.table
    output:
        dir("results/qiime/core-diversity/"),
        even="results/qiime/core-diversity/evenness_vector.qza",
        faith="results/qiime/core-diversity/faith_pd_vector.qza"
    log:
        "logs/qiime_core-metrics.log"
    threads: 6
    params:
        depth=16000,
        meta="metadata.tsv"
    shell:
        ("qiime diversity core-metrics-phylogenetic  --i-phylogeny {input.tree} "
        "--i-table {input.table} --p-sampling-depth {params.depth} "
        "--m-metadata-file {params.meta} --output-dir {output} &> {log}")


rule alpha_evennes:
    input:
        "results/qiime/core-diversity/evenness_vector.qza"
    output:
        "results/qiime/vis/evenness_stats.qzv"
    log:
        "logs/qiime_evenness.log"
    params:
        meta="metadata.tsv"
    shell:
        ("qiime diversity alpha-group-significance --i-alpha-diversity {input} " 
        "--m-metadata-file {params.meta} --o-visualization {output}")
            
        
rule alpha_faith:
    input:
        "results/qiime/core-diversity/faith_pd_vector.qza"
    output:
        "results/qiime/vis/faiths_pd_statistics.qzv"
    log:
        "logs/qiime_faith.log"
    params:
        meta="metadata.tsv"        
    shell:
        ("qiime diversity alpha-group-significance --i-alpha-diversity {input} "
        "--m-metadata-file {params.meta} --o-visualization {output}  &> {log}")
