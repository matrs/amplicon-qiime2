rule alpha_rare:
    input:
        rules.dada2.output.feat_table
    output:
        "results/qiime/vis/alpha_rarefication.qzv"
    log:
        "logs/qiime_alpha-rare.log"
    params:
        meta="metadata.tsv",
        min_depth=100,
        max_depth=145000
    shell:
        ("qiime diversity alpha-rarefaction --i-table {input} "
        "--m-metadata-file {params.meta} --o-visualization {output} "
        "--p-min-depth  {params.min_depth} --p-max-depth {params.max_depth} &> {log}")
    
    
rule core_metrics:
    input:
        tree=rules.fragment_insertion.output.tree,
        table=rules.dada2.output.feat_table
    output:
        table="results/qiime/core_diversity/table.qza",
        faith="results/qiime/core_diversity/faith_pd_vector.qza",
        otus="results/qiime/core_diversity/observed-otus-vector.qza",
        shannon="results/qiime/core_diversity/shannon-vector.qza",
        even="results/qiime/core_diversity/evenness-vector.qza",
        unw_uni_dist="results/qiime/core_diversity/unweighted_unifrac_distance_matrix.qza",
        wei_uni_dist="results/qiime/core_diversity/weighted_unifrac_distance_matrix.qza",
        jac_dist="results/qiime/core_diversity/jaccard-distance-matrix.qza",
        bray_dist="results/qiime/core_diversity/bray-curtis-distance-matrix.qza",
        unw_uni_pcoa="results/qiime/core_diversity/unweighted_unifrac_pcoa_results.qza",
        wei_uni_pcoa="results/qiime/core_diversity/weighted_unifrac_pcoa_results.qza",
        jac_pcoa="results/qiime/core_diversity/jaccard-pcoa-results.qza",
        bray_pcoa="results/qiime/core_diversity/bray-curtis-pcoa-results.qza",
        unw_uni_emp="results/qiime/vis/unweighted_unifrac_emperor.qzv",
        wei_uni_emp="results/qiime/vis/weighted_unifrac_emperor.qzv",
        jac_emp="results/qiime/vis/jaccard-emperor.qzv",
        bray_emp="results/qiime/vis/bray-curtis-emperor.qzv"
    log:
        "logs/qiime_core-metrics.log"
    threads: 6
    params:
        depth=16000,
        meta="metadata.tsv"
    shell:
        ("qiime diversity core-metrics-phylogenetic  --i-phylogeny {input.tree} "
        "--i-table {input.table} --p-sampling-depth {params.depth} --m-metadata-file {params.meta} "
        "--o-rarefied-table                    {output.table} "                                     
        "--o-faith-pd-vector                   {output.faith} "                                     
        " --o-observed-otus-vector             {output.otus} "                                      
        "--o-shannon-vector                    {output.shannon} "                                   
        "--o-evenness-vector                   {output.even} "                                      
        "--o-unweighted-unifrac-distance-matrix {output.unw_uni_dist} "                             
        "--o-weighted-unifrac-distance-matrix  {output.wei_uni_dist} "                              
        "--o-jaccard-distance-matrix           {output.jac_dist} "                                  
        "--o-bray-curtis-distance-matrix       {output.bray_dist} "                                 
         "--o-unweighted-unifrac-pcoa-results   {output.unw_uni_pcoa} "                              
         "--o-weighted-unifrac-pcoa-results     {output.wei_uni_pcoa} "                              
         "--o-jaccard-pcoa-results              {output.jac_pcoa} "                                  
         "--o-bray-curtis-pcoa-results          {output.bray_pcoa} "                                 
         "--o-unweighted-unifrac-emperor        {output.unw_uni_emp} "                               
         "--o-weighted-unifrac-emperor          {output.wei_uni_emp} "                               
         "--o-jaccard-emperor                   {output.jac_emp} "                                   
         "--o-bray-curtis-emperor               {output.bray_emp} &> {log}")

rule alpha_evenness:
    input:
        rules.core_metrics.output.even
    output:
        "results/qiime/vis/evenness_stats.qzv"
    log:
        "logs/qiime_evenness.log"
    params:
        meta="metadata.tsv"
    shell:
        ("qiime diversity alpha-group-significance --i-alpha-diversity {input} " 
        "--m-metadata-file {params.meta} --o-visualization {output} &> {log}")
            
        
rule alpha_faith:
    input:
        rules.core_metrics.output.faith
    output:
        "results/qiime/vis/faiths_pd_statistics.qzv"
    log:
        "logs/qiime_faith.log"
    params:
        meta="metadata.tsv"        
    shell:
        ("qiime diversity alpha-group-significance --i-alpha-diversity {input} "
        "--m-metadata-file {params.meta} --o-visualization {output}  &> {log}")

rule beta_diversity_unweighted:
    input:
        "results/qiime/core_diversity/unweighted_unifrac_distance_matrix.qza",
    output:
        "results/qiime/vis/unweighted_unifrac_distance_matrix.qzv"
    log:
        "logs/beta_div_unweighted.log"
    params:
        meta="metadata.tsv",
        column=config["beta_diversity"]["column"]
    shell:
        ("qiime diversity beta-group-significance --i-distance-matrix {input} "
        "--m-metadata-file {params.meta} --m-metadata-column {params.column} "
        "--o-visualization {output}  &> {log}")

rule beta_diversity_weighted:
    input:
        "results/qiime/core_diversity/weighted_unifrac_distance_matrix.qza",
    output:
        "results/qiime/vis/weighted_unifrac_distance_matrix.qzv"
    log:
        "logs/beta_div_weighted.log"
    params:
        meta="metadata.tsv",
        column=config["beta_diversity"]["column"]
    shell:
        ("qiime diversity beta-group-significance --i-distance-matrix {input} "
        "--m-metadata-file {params.meta} --m-metadata-column {params.column} "
        "--o-visualization {output}  &> {log}")


#Filter feature table according to rarification depth
rule filter_table_byrare:
    input:
        rules.dada2.output.feat_table
    output:
        "results/qiime/dada_table_rare-filter.qza"
    log:
        "logs/qiime_rarification_filter.log"
    params:
        16000
    shell:
        ("qiime feature-table filter-samples --i-table {input} --p-min-frequency {params} "
        "--o-filtered-table {output} &> {log}")
  
  
