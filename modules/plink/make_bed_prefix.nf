process CONVERT_VCF_TO_BED{

    tag { "converting_vcf_to_bed_${chrom}" }
    label "oneCpu"
    conda "${baseDir}/environment.yml"
    container "maulik23/scalepopgen:0.1.1"
    publishDir("${params.outDir}/bed_file/", mode:"copy")

    input:
        val(chrom)

    output:
        path("chroms_bed_prefix.txt"), emit: chrom_prefix_file

    when:
        task.ext.when == null || task.ext.when

    script:
        
        chrom_sorted = chrom.sort{ it }
        
        """
        
        for z in $chrom_sorted;do echo \$z"\n";done > chroms_bed_prefix.txt
        

        """ 
}
