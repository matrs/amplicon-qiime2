rule filter_low_ASVs:
    input:
        "results/qiime/dada_table.qza"
    output:
        "results/qiime/diffabund/dada_table_filtered.qza"
    log:
        "logs/qiime_tabulate_taxonomy.log"
    params:
        min_freq=10,
        min_samples=2
    conda:
        "../envs/qiime2-2019.7.yaml"
    shell:
        ("qiime feature-table filter-features --i-table {input} "
        "--p-min-frequency {params.min_freq} --p-min-samples {params.min_samples} "
        "--o-filtered-table {output} &> {log}")

        
rule add_pseudocount:
    input:
        "results/qiime/diffabund/dada_table_filtered.qza"
    output:
        "results/qiime/diffabund/dada_table_pseudo-count.qza"
    log:
        "logs/qiime_add_pseudocount.log"
    params:
    conda:
        "../envs/qiime2-2019.7.yaml"
    shell:
        ("qiime composition add-pseudocount --i-table {input} "
        "--o-composition-table {output} &> {log}")

#running time can be 2-3 hours or more, no multi-thread available
rule ancom:
    input:
        "results/qiime/diffabund/dada_table_pseudo-count.qza"
    output:
        "results/qiime/vis/ancom_description.qzv"
    log:
        "logs/qiime_ancom.log"
    params:
        meta="metadata.tsv",
        column="description"
    conda:
        "../envs/qiime2-2019.7.yaml"
    shell:
        ("qiime composition ancom --i-table {input} --m-metadata-file {params.meta} "
        "--m-metadata-column {params.column} --o-visualization {output}")
        
        
rule taxo_collapse:
    input:
        feat_table="results/qiime/diffabund/dada_table_filtered.qza",
        taxo="results/qiime/taxonomy/silva_taxonomy.qza"
    output:
        "results/qiime/diffabund/dada_table_collapse-l6.qza"
    log:
        "logs/taxo_collapse.log"
    params:
        level=6
    conda:
        "../envs/qiime2-2019.7.yaml"
    shell:
        ("qiime taxa collapse --i-table {input.feat_table} --i-taxonomy {input.taxo} "
        "--p-level {params.level} --o-collapsed-table {output}")
        
rule add_pseudocount_collapsed:
    input:
        "results/qiime/diffabund/dada_table_collapse-l6.qza"
    output:
        "results/qiime/diffabund/dada_table_collapse-l6_pseudo-count.qza"
    log:
        "logs/qiime_add_pseudocount_taxo.log"
    params:
    conda:
        "../envs/qiime2-2019.7.yaml"
    shell:
        ("qiime composition add-pseudocount --i-table {input} "
        "--o-composition-table {output} &> {log}")

rule ancom_collapsed:
    input:
        "results/qiime/diffabund/dada_table_collapse-l6_pseudo-count.qza"
    output:
        "results/qiime/vis/ancom_description-l6.qzv"
    log:
        "logs/ancom_collapsed.log"
    params:
        meta="metadata.tsv",
        column="description"
    conda:
        "../envs/qiime2-2019.7.yaml"
    shell:
        ("qiime composition ancom --i-table {input} --m-metadata-file {params.meta} "
        "--m-metadata-column {params.column} --o-visualization {output}")
        
        
        
