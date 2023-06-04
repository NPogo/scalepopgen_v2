process CONVERT_PED_TO_BED{

	tag { "ped_to_bed" }
	label "oneCpu"
	container "maulik23/scalepopgen:0.1.1"

	input:
	tuple val(chrom), file(plink_files)

	output:
	tuple val("${chrom}"),path("*.{bed,bim,fam}"), emit: bed
	
	when:
    	task.ext.when == null || task.ext.when

	script:

	def max_chrom     = params.max_chrom

	if(!params.allow_extra_chrom){

		"""
		  plink2 -file ${chrom} --make-bed --out ${chrom} --chr-set ${max_chrom}
		    
		"""
	}

	else{
		"""

		    plink2 -file ${chrom} --make-bed --out ${chrom} --allow-extra-chr --chr-set ${max_chrom}

		"""
	}

}
