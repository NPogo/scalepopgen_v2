process RUN_SMARTPCA {

    tag { "running_smartpca_${new_prefix}" }
    label "oneCpu"
    conda "${baseDir}/environment.yml"
    container "maulik23/scalepopgen:0.1.1"
    publishDir("${params.outDir}/genetic_structure/pca_results/", mode:"copy")

    input:
        file(bed)

    output:
        path("*{.eigen*,.snp,.ind,.evec,.eval}")

    when:
     task.ext.when == null || task.ext.when

    script:
        new_prefix = bed[0].baseName
        def smartpca_param = params.smartpca_param
        def max_chrom = params.max_chrom
        def opt_arg = ""
        opt_arg = opt_arg + " --chr-set "+ max_chrom
        
	if( params.allow_extra_chrom ){
                
            opt_arg = opt_arg + " --allow-extra-chr "

            }

        opt_arg = opt_arg + " --recode --out " +new_prefix
        

        """

	awk '{familyId[\$1];next}END{for(id in familyId){print id}}' ${new_prefix}.fam > family.id

        ###command is needed to convert bed to ped 

	plink --bfile ${new_prefix} ${opt_arg}

	awk '\$6=\$1' ${new_prefix}.ped > ${new_prefix}.1.ped

	python3 ${baseDir}/bin/createParEigenstrat.py ${new_prefix} convertf ${max_chrom} NA

	convertf -p ${new_prefix}.pedToEigenstraat.par

	python3 ${baseDir}/bin/createParSmartpca.py ${new_prefix} ${max_chrom} ${task.cpus} ${smartpca_param}

	smartpca -p ${new_prefix}.smartpca.par > ${new_prefix}.eigen.log


        """ 
}
