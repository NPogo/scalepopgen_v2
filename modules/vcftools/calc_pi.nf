process CALC_PI{

    tag { "calculating_pi" }
    label "oneCpu"
    container "maulik23/scalepopgen:0.1.1"
    conda "${baseDir}/environment.yml"
    publishDir("${params.outDir}/selection/unphased_data/pi_values/${prefix}/", mode:"copy")

    input:
        tuple val(prefix), path(vcf), path(sample_id)

    output:
        tuple val(pop), path ("${pop}_${prefix}_${window_size}*"), emit: pi_out

    script:
        
        pop = sample_id.baseName
        
        window_size = params.sel_window_size

        """
        vcftools --gzvcf ${vcf} --keep ${sample_id} --window-pi ${window_size} --out ${pop}_${prefix}_${window_size}

        """ 
}
