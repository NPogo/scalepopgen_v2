process MERGE_BED{

    tag { "merging_bed_${prefix}" }
    label "oneCpu"
    conda "${baseDir}/environment.yml"
    container "maulik23/scalepopgen:0.1.1"
    publishDir( "${params.outDir}/plink/" , mode:"copy")

    input:
        file(bed)
        file(sample_map)

    output:
        path("${prefix}.{bed,bim,fam}"), emit: merged_bed
        path("*.log"), emit: merged_bed_log

    when:
        task.ext.when == null || task.ext.when

    script:
        prefix = "merged_all_chrom_"+bed[0].baseName.split("__")[1]
        def max_chrom = params.max_chrom
        def opt_arg = ""
        opt_arg = opt_arg + " --chr-set "+ max_chrom
	if( params.allow_extra_chrom ){
                
            opt_arg = opt_arg + " --allow-extra-chr "

            }
        
        """

        ls *.fam|sed 's/\\.fam//g' > prefix_list.txt

	plink2 ${opt_arg} --pmerge-list prefix_list.txt bfile --make-bed --out ${prefix}

        awk 'NR==FNR{pop[\$1]=\$2;next}{\$1=pop[\$2];print}' ${sample_map} ${prefix}.fam > ${prefix}.1.fam

        rm ${prefix}.fam

        mv ${prefix}.1.fam ${prefix}.fam

        """ 
}
