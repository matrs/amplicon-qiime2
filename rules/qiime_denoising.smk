rule dada2:
    input:
        rules.qiime_import.output
    output:
        feat_table="results/qiime/dada_table.qza",
        stats="results/qiime/dada_stats.qza",
        rep_seq="results/qiime/dada_rep-seqs.qza"
    log:
        "logs/qiime_dada.log"
    params:
        config["params"]["dada2"]    
    threads:12 #To use all available threads
    shell:
        ("qiime dada2 denoise-paired --i-demultiplexed-seqs {input} "
        "{params} --p-n-threads {threads} --o-table {output.feat_table} "
        "--o-denoising-stats {output.stats} --o-representative-sequences {output.rep_seq} " 
        "--verbose &> {log} ")

rule feat_table_summary:
    input:
        rules.dada2.output.feat_table
    output:
        "results/qiime/vis/table.qzv"
    log:
        "logs/qiime_table_summ.log"
    shell:
            "qiime feature-table summarize --i-table {input} --o-visualization {output} --verbose &> {log}"

rule denoi_summary:
    input:
        rules.dada2.output.stats
    output:
        "results/qiime/vis/denoi_stats.qzv"
    log:
        "logs/qiime_table_summ.log"
    shell:
        "qiime metadata tabulate --m-input-file {input} --o-visualization {output} --verbose &> {log}"

rule rep_seqs_summary:
    input:
        rules.dada2.output.rep_seq
    output:
        "results/qiime/vis/rep_seqs.qzv"
    log:
        "logs/qiime_repseqs_summ.log"
    shell:
        ("qiime feature-table tabulate-seqs --i-data {input} --o-visualization "
        "{output} --verbose &> {log}")