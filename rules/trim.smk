rule cutadapt_pe:
    input:
        get_fastqs
    output:
        fastq1="trimmed/{sample}_{unit}.1.fastq.gz",
        fastq2="trimmed/{sample}_{unit}.2.fastq.gz",
        qc="trimmed/{sample}_{unit}_pe_qc.txt"
    params:
        adapters_r1="-a {}".format(config["adapterF"], config["params"]["cutadapt-pe"]),
        adapters_r2="-A {}".format(config["adapterR"]),
        others="-j 2 -m 215 -M 285 --discard-untrimmed "
    log:
        "logs/cutadapt/{sample}_{unit}.log"
    wrapper:
        "0.36.0/bio/cutadapt/pe"


rule cutadapt:
    input:
        get_fastqs
    output:
        fastq="trimmed/{sample}_{unit}_fastq.gz",
        qc="trimmed/{sample}_{unit}_qc.txt"
    params:
        "-a {}".format(config["adapterF"])
    log:
        "logs/cutadapt/{sample}_{unit}.log"
    wrapper:
        "0.36.0/bio/cutadapt/se"

from pathlib import Path
path=Path("trimmed")
wildcards, = glob_wildcards(path.joinpath("{sample}.fastq.gz"))
#print(wildcards)
rule make_samples:
    input:
        expand("trimmed/{sample}.fastq.gz", sample=wildcards)
    output:
        "samples_qiime.tsv"
    log:
        "logs/make_samples.log"
    script:
        "../scripts/make_qiime_samples.py"
