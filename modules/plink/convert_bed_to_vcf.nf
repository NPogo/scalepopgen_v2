process CONVERT_BED_TO_VCF{

    tag { "convert_plinkBedToVcf" }
    label "oneCpu"
    container "maulik23/scalepopgen:0.1.1"
    publishDir("${params.outDir}/vcf", mode:"copy")

    input:
        tuple val(chrom), file(plink_files)

    output:
        tuple val(chrom), path("${chrom}.vcf.gz"), emit:vcfgz
        path("sample_family.id"), emit: id

    when:
     task.ext.when == null || task.ext.when

    script:
        
	def max_chrom = params.max_chrom

	if( !params.allow_extra_chrom ){

        """

	awk '{print \$2"\\t"\$1}' *.fam > sample_family.id

	plink2 --bfile ${chrom} --chr-set ${max_chrom} --recode vcf 

    awk 'BEGIN{IFS="\\t";OFS="\\t"}NR==FNR{newSampleId = \$2"_"\$1;newSampleIdArray[newSampleId]=\$1;next}{if(\$0~/#CHROM/){for(i=1;i<NF;i++){(i>9) ? sample = newSampleIdArray[\$i]: sample = \$i;printf sample"\\t"};printf newSampleIdArray[\$NF]"\\n";next}else;print}' sample_family.id plink.vcf > ${chrom}.vcf

    bgzip ${chrom}.vcf

	rm plink.vcf


        """ 
	}
	else{

	"""
	
	awk '{print \$2"\\t"\$1}' *.fam > sample_family.id

	plink2 --bfile ${chrom} --chr-set ${max_chrom} --allow-extra-chr --recode vcf 

    awk 'BEGIN{IFS="\\t";OFS="\\t"}NR==FNR{newSampleId = \$2"_"\$1;newSampleIdArray[newSampleId]=\$1;next}{if(\$0~/#CHROM/){for(i=1;i<NF;i++){(i>9) ? sample = newSampleIdArray[\$i]: sample = \$i;printf sample"\\t"};printf newSampleIdArray[\$NF]"\\n";next}else;print}' sample_family.id plink.vcf > ${chrom}.vcf

    bgzip ${chrom}.vcf

	rm plink.vcf

	"""
	}
}
