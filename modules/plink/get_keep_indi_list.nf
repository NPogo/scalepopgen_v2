process GET_KEEP_INDI_LIST{

    tag { "calc_missing_${prefix}" }
    label "oneCpu"
    conda "${baseDir}/environment.yml"
    container "maulik23/scalepopgen:0.1.1"
    publishDir("${params.outDir}/plink/indi_filtered/", mode:"copy")

    input:
        file(bed)

    output:
        path("*miss"), emit: missing_indi_report
        path("${prefix}_indi_kept*"), emit: missigness_filt_bed
        path("indi_kept.txt"), emit: keep_indi_list
        path("indi_kept.map"), emit: keep_indi_map
        path("*.log" ), emit: log_file

    when:
        task.ext.when == null || task.ext.when

    script:
        prefix = bed[0].baseName
        def max_chrom = params.max_chrom
        def opt_arg = ""
        opt_arg = opt_arg + " --chr-set "+ max_chrom
	if( params.allow_extra_chrom ){
                
            opt_arg = opt_arg + " --allow-extra-chr "

            }

        if ( params.rem_indi != "none" ){
        
            opt_arg = opt_arg + " --remove " + params.rem_indi
        }
        
        if ( params.mind > 0 ){
        
            opt_arg = opt_arg + " --mind " + params.mind
        }
        if ( params.king_cutoff > 0 ){
        
            opt_arg = opt_arg + " --king-cutoff " + params.king_cutoff 
        }

        opt_arg = opt_arg + " --make-bed --missing --out " + prefix +"_indi_kept"
        
        """
	
        plink2 --bfile ${prefix} ${opt_arg}
            
        awk '{print \$2}' ${prefix}_indi_kept.fam > indi_kept.txt

        awk '{print \$2,\$1}' ${prefix}_indi_kept.fam > indi_kept.map


        """ 
}
