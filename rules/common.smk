from snakemake.utils import validate
import pandas as pd



##### load config and sample sheets #####

configfile: "config.yaml"
#validate(config, schema="../schemas/config.schema.yaml")

# samples = pd.read_csv(config["samples"], sep="\t").set_index("sample", drop=False)
# samples.index.names = ["sample_id"]
#validate(samples, schema="../schemas/samples.schema.yaml")

units = pd.read_csv(
    config["units"], dtype=str, sep="\t").set_index(["sample", "unit"], drop=False)
units.index.names = ["sample_id", "unit_id"]
units.index = units.index.set_levels(
    [i.astype(str) for i in units.index.levels])  # enforce str in index
#validate(units, schema="../schemas/units.schema.yaml")

# print("unit df:", units, sep='\n')
####### helpers ###########

def is_single_end(sample, unit):
    """Determine whether unit is single-end."""
    return pd.isnull(units.loc[(sample, unit), "fq2"])

def get_fastqs(wildcards):
    """Get raw FASTQ files from unit sheet."""
    return units.loc[
        (wildcards.sample, wildcards.unit), ["fq1", "fq2"]].dropna()

def get_trimmed(wildcards):
    if not is_single_end(**wildcards):
        # paired-end sample
        return expand("trimmed/{sample}-{unit}.{group}.fastq.gz",
                      group=[1, 2], **wildcards)
    # single end sample
    return expand("trimmed/{sample}-{unit}.fastq.gz", **wildcards)

