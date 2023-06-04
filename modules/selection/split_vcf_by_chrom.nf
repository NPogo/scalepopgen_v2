process SPLIT_VCF_BY_CHROM{

    tag { "splitting_by_chrom" }
    label "oneCpu"
    container "maulik23/scalepopgen:0.1.1"

    input:
        tuple val(prefix), path(vcfIn)

    output:
        path ("*.split.vcf.gz"), emit: splitted_vcfs

    script:
        
        """
        awk '{if(\$0~/#/){if(\$0~/#contig/){match(\$0,/(##contig=<ID=)([^,]+)(.*)/,a);print a[2]>"chrom.id.txt";next}else;next}else;exit 0}' <(zcat < ${vcfIn})

        while read chrom;do vcftools --gzvcf ${vcfIn} --chr \${chrom} --recode --stdout|bgzip -c > \${chrom}.split.vcf.gz;done<chrom.id.txt

        """ 
}
