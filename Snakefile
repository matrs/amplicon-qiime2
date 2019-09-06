include: "rules/common.smk"
include: "rules/trim.smk"
include: "rules/qc.smk"
include: "rules/qiime_import.smk"
include: "rules/qiime_denoising.smk"
include: "rules/qiime_phylo.smk"
include: "rules/qiime_diversity.smk"
include: "rules/qiime_taxonomy.smk"
include: "rules/diff_abund.smk"

#Depending which part of the pipeline you want to run, you can comment/uncomment out targets
rule all:
    input:
        "qc/multiqc_posttrim.html",
        "results/qiime/vis/reads.qzv",
        "results/qiime/vis/table.qzv",
        "results/qiime/vis/denoi_stats.qzv",
        "results/qiime/vis/rep_seqs.qzv",
        #"results/qiime/phylo/sepp_tree.qza",
        #"results/qiime/phylo/aligned_rep-seqs.qza",
        "results/qiime/vis/alpha_rarefication.qzv",
        "results/qiime/phylo/mafft_rep-seqs_masked.qza",
        "results/qiime/vis/faiths_pd_statistics.qzv",
        "results/qiime/vis/evenness_stats.qzv",
        "results/qiime/vis/weighted_unifrac_distance_matrix.qzv",
        "results/qiime/vis/unweighted_unifrac_distance_matrix.qzv",
        #"results/qiime/taxonomy/silva_taxonomy.qza",
        #"results/qiime/vis/silva_taxonomy.qzv",
        "results/krona.html",
        "results/qiime/vis/taxa-bar_silva_taxonomy.qzv",
        "results/qiime/vis/ancom_description.qzv",
        "results/qiime/vis/ancom_description-l6.qzv"


        
