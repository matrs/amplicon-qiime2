rule qiime_import:
    input:
        "samples_qiime.tsv"
    output:
        "results/qiime/reads.qza"
    log:
        "logs/qiime_import.log"
    params:
        type="SampleData[PairedEndSequencesWithQuality]" ,
        format="PairedEndFastqManifestPhred33V2"
    shell:
        ("qiime tools import --type {params.type} --input-path {input} "
        "--output-path {output} --input-format {params.format} &> {log}")

rule demux_summary:
    input:
        rules.qiime_import.output
    output:
        "results/qiime/vis/reads.qzv"
    log:
        "logs/qiime_demux-summary.log"
    params:
    priority:1
    shell:
        "qiime demux summarize --i-data {input} --o-visualization {output}"
