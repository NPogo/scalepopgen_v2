process CONCAT_VCF{

    tag { "concate_vcf" }
    label "oneCpu"
    container "maulik23/scalepopgen:0.1.1"
    conda "${baseDir}/environment.yml"
    publishDir("${params.outDir}/selection/${prefix}/", mode:"copy")

    input:
        path(vcf)

    output:
        path ("all_chrm.concated.vcf.gz"), emit: concated_vcf

    script:
        

        """
        vcf-concat $vcf|bgzip -c > all_chrm.concated.vcf.gz

        """ 
}
