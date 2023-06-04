process REM_INDI{

    tag { "rem_indi_${chrom}" }
    label "oneCpu"
    container "maulik23/scalepopgen:0.1.1"
    conda "${baseDir}/environment.yml"
    publishDir("${params.outDir}/vcf_filtering/", mode:"copy")

    input:
        tuple val(chrom), path(vcf)

    output:
        tuple val(chrom), path ("${chrom}.rem_indi.vcf.gz"), emit: indi_filt
        path("*.imiss")

    script:
        geno_cutoff = params.geno
        if( params.rem_indi != "none" ){
            def indi_list = params.rem_indi

        """
        

        vcftools --gzvcf ${vcf} --missing-indv 

        awk -v cutoff=$geno_cutoff 'NR>1 && \$5>cutoff{print \$1}' out.imiss > rem_indi_list.1.txt
    
        cat ${params.rem_indi} rem_indi_list.1.txt|awk '{sample[\$1];next}END{(for i in sample){print \$i}} > rem_indi_list.2.txt

        vcftools --gzvcf ${vcf} --remove rem_indi_list.2.txt --recode --stdout | bgzip -c > ${chrom}.rem_indi.vcf.gz


        """ 
        }

        else{

        """
        vcftools --gzvcf ${vcf} --missing-indv 

        awk -v cutoff=$geno_cutoff 'NR>1 && \$5>cutoff{print \$1}' out.imiss > rem_indi_list.1.txt

        vcftools --gzvcf ${vcf} --remove rem_indi_list.1.txt --recode --stdout | bgzip -c > ${chrom}.rem_indi.vcf.gz

        """ 

        }
}
