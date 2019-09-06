#Memory consumption at its peak is 20gb per core, needed 200gb to use 10 cores without failing
rule scikit_classifier:
    input:
        seq=rules.dada2.output.rep_seq,
        db=config["classifierDB"]
    output:
        "results/qiime/taxonomy/silva_taxonomy.qza"
    log:
        "logs/qiime_scikit_classifier.log"
    threads: 10
    conda:
        "../envs/qiime2-2019.7.yaml"
    shell:
        ("qiime feature-classifier classify-sklearn --i-classifier {input.db} "
        "--i-reads {input.seq} --p-n-jobs {threads} --o-classification {output} "
        "--verbose &> {log}")

rule tabulate_taxonomy:
    input:
        "results/qiime/taxonomy/silva_taxonomy.qza"
    output:
        "results/qiime/vis/silva_taxonomy.qzv"
    log:
        "logs/qiime_tabulate_taxonomy.log"
    conda:
        "../envs/qiime2-2019.7.yaml"
    shell:
        "qiime metadata tabulate --m-input-file {input} --o-visualization {output} &> {log}"
        

rule barplot_taxonomy:
    input:
        taxo="results/qiime/taxonomy/silva_taxonomy.qza",
        table=rules.filter_table_byrare.output
    output:
        "results/qiime/vis/taxa-bar_silva_taxonomy.qzv"
    log:
        "logs/qiime_tabulate_taxonomy.log"
    params:
        "metadata.tsv"
    conda:
        "../envs/qiime2-2019.7.yaml"
    shell:
        ("qiime taxa barplot --i-table  {input.table} --i-taxonomy {input.taxo} "
        "--m-metadata-file {params} --o-visualization {output} &> {log}")


rule artifact_to_krona:
    input:
        taxo_art="results/qiime/taxonomy/silva_taxonomy.qza",
        feat_art="results/qiime/dada_table.qza"
    output:
        dir=directory("results/krona/")
    log:
        "logs/qiime2krona.log"
    conda:
        "../envs/qiime2-2019.7.yaml"
    shell:
        "python scripts/qiime2krona.py {input.taxo_art} {input.feat_art}  {output.dir}"

#Not able to use directory() as path of the output ==> ChildIOException
rule krona_plot:
    input:
        rules.artifact_to_krona.output
    output:
        "results/krona.html"
    conda:
        "../envs/krona.yaml"
    shell:
        "ktImportText -o {output} results/krona/*.tsv -c"
        
