    # seqkit stats -j 12 reads/*/*/*.gz -T -a | csvtk csv2md -t > fastq_seqkit.stats
rule fastqc:
    input:
       "trimmed/{sample}_{unit}.fastq.gz"
    output:
        html="qc/fastqc/trimmed/{sample}_{unit}_fastqc.html",
        zip="qc/fastqc/trimmed/{sample}_{unit}_fastqc.zip"
    log:
       "logs/fastqc/{sample}_{unit}.log"
    params:""
    wrapper:
       "0.36.0/bio/fastqc"

rule multiqc:
    input:
        expand("qc/fastqc/trimmed/{unit.sample}_{unit.unit}.{R}_fastqc.zip", unit=units.itertuples(), R=[1,2]),
        expand("trimmed/{unit.sample}_{unit.unit}_qc.txt", unit=units.itertuples()) 
    output:
        "qc/multiqc_posttrim.html"
    log:
        "logs/multiqc.log"
    params:
        config["params"]["multiqc"]
    wrapper:
        "0.36.0/bio/multiqc"