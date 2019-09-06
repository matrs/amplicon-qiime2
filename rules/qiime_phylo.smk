# `sepp` plugin doesn't filter distant sequences because it was thougth for sequences coming 
# from deblur so it's possible that inserts sequences that are distant (e.g non-16s seqs), 
# into the tree.
# By default , sepp uses greengenes, silva 128 is available but not benchmarked yet
# also, sepp needs memory, 40gb, https://github.com/qiime2/q2-fragment-insertion/issues/49
rule fragment_insertion:
    input:
        rules.dada2.output.rep_seq
    output:
        tree="results/qiime/phylo/sepp_tree.qza",
        placements="results/qiime/sepp_placements.qza"
    log:
        "logs/qiime_sepp.log"
    threads: 12
    priority: 1
    conda:
        "../envs/qiime2-2019.7.yaml"
    shell:
        ("qiime fragment-insertion sepp --i-representative-sequences {input} "
        "--o-tree {output.tree} --o-placements {output.placements} --p-threads {threads} "
        "--verbose &> {log}")


rule mafft_fastree:
    input:
        rules.dada2.output.rep_seq
    output:
        align_seqs="results/qiime/phylo/aligned_rep-seqs.qza",
        masked_align="results/qiime/phylo/alig_masked_rep-seqs.qza",
        unroot="results/qiime/phylo/unrooted_tree.qza",
        rooted="results/qiime/phylo/rooted_tree.qza"
    log:
      "logs/qiime_mafft_fastree.log"
    threads: 6
    conda:
        "../envs/qiime2-2019.7.yaml"
    shell:
        ("qiime phylogeny align-to-tree-mafft-fasttree --i-sequences {input} "
        "--o-alignment {output.align_seqs} --o-masked-alignment {output.masked_align} "    
        "--o-tree {output.unroot} --o-rooted-tree {output.rooted} --p-n-threads {threads} "
        " &> {log}")

rule alignment:
    input:
        rules.dada2.output.rep_seq
    output:
        "results/qiime/phylo/mafft_rep-seqs.qza"
    log:
        "logs/qiime_mafft.log"
    threads: 6
    conda:
        "../envs/qiime2-2019.7.yaml"
    shell:
        ("qiime alignment mafft --i-sequences {input} --p-n-threads 6  "
        "--o-alignment {output} &> {log}")

rule mask_alignment:
    input:
        rules.alignment.output
    output:
        "results/qiime/phylo/mafft_rep-seqs_masked.qza"
    log:
        "logs/qiime_mafft_masked.log"
    conda:
        "../envs/qiime2-2019.7.yaml"
    shell:
        "qiime alignment mask --i-alignment {input}  --o-masked-alignment {output}"


        
        
    
        
