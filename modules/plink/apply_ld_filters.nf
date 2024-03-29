process APPLY_LD_FILTERS{

    tag { "ld_filtering_${new_prefix}" }
    label "oneCpu"
    conda "${baseDir}/environment.yml"
    container "maulik23/scalepopgen:0.1.1"
    publishDir("${params.outDir}/pca/", mode:"copy")

    input:
        file(bed)

    output:
        path("${new_prefix}_ld_filtered.{bed,bim,fam}"), emit: ld_filt_bed

    when:
        task.ext.when == null || task.ext.when

    script:
        new_prefix = bed[0].baseName
        def max_chrom = params.max_chrom
        def opt_arg = ""
        opt_arg = opt_arg + " --chr-set "+ max_chrom
        
	if( params.allow_extra_chrom ){
                
            opt_arg = opt_arg + " --allow-extra-chr "

            }

        opt_arg1 = opt_arg + " --indep-pairwise "+params.ld_window_size+" "+params.step_size+" "+params.r2_value
        opt_arg2 = opt_arg + " --extract plink.prune.in --make-bed --out "+new_prefix+"_ld_filtered"

	
        """

        plink2 --bfile ${new_prefix} ${opt_arg1}

        plink2 --bfile ${new_prefix} ${opt_arg2}

        """ 

}
