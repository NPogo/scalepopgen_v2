process SPLIT_IDFILE_BY_POP{

    tag { "splitting_idfile_by_pop" }
    label "oneCpu"
    conda "${baseDir}/environment.yml"
    container "maulik23/scalepopgen:0.1.1"

    input:
        path(sample_map)

    output:
        path ("*.txt"), emit: splitted_samples

    script:
        
        """
        
        awk '{print \$1 >>\$2".txt"}' ${sample_map}

        """ 
}
