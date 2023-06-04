process KEEP_INDI{

    tag { "keep_indi_${chrom}" }
    label "oneCpu"
    container "maulik23/scalepopgen:0.1.1"
    conda "${baseDir}/environment.yml"
    publishDir("${params.outDir}/vcftools/indi_filtering/", mode:"copy")

    input:
        tuple val(chrom), file(vcf), file(indi_list)

    output:
        tuple val(chrom), file("${chrom}_filt_samples.vcf.gz"),emit:filt_chrom_vcf
    
    script:
        prefix = params.prefix
    
        """
        
        vcftools --gzvcf ${vcf} --keep ${indi_list} --recode --stdout |bgzip -c > ${chrom}_filt_samples.vcf.gz


        """ 
}
