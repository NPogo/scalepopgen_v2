process EST_BESTK_PLOT {

    tag { "estimating_bestK" }
    label "oneCpu"
    conda "${baseDir}/environment.yml"
    container "maulik23/scalepopgen:0.1.1"
    publishDir("${params.outDir}/genetic_structure/admixture_results/", mode:"copy")
    errorStrategy 'ignore'

    input:
	path(k_cv_log_files)

    output:
	path("*.png")

    when:
     	task.ext.when == null || task.ext.when

    script:

	def best_kval_method = params.best_kval_method
        
        """
	
	python3 ${baseDir}/bin/estBestkAndPlot.py ${best_kval_method} ${k_cv_log_files}
	
        
	""" 

}
