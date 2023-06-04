#!/usr/bin/Rscript

library("ggplot2")
library("lattice")
library("optparse")
library("RColorBrewer")

args=commandArgs(TRUE)


runPCA=function(stem,chr,colr){
    library("SNPRelate")
    bedB.fn=paste(stem,".bed",sep="")
    bedf.fn=paste(stem,".fam",sep="")
    bedBi.fn=paste(stem,".bim",sep="")
    gds.fn = paste(stem,".gds", sep="")
    eigenvectOut = paste(stem,".eigenvect", sep="")
    varpropOut = paste(stem,".varprop",sep="")
    jpgOut = paste(stem,".jpeg",sep="")
    #convert bed to gds format
    snpgdsBED2GDS(bedB.fn,bedf.fn,bedBi.fn,family=TRUE,option = snpgdsOption(autosome.end=as.numeric(chr)), gds.fn)
    genofile=snpgdsOpen(gds.fn)
    pca=snpgdsPCA(genofile,num.thread=1,autosome.only=FALSE)
    sample.id=pca$sample.id
    #extract first and second eigenvectors values
    EV1=pca$eigenvect[,1]
    EV2=pca$eigenvect[,2]
    tab=data.frame(sample.id,pca$eigenvect, stringsAsFactors=FALSE)
    tab1=data.frame(pca$varprop)
    pop.id=read.gdsn(index.gdsn(genofile,"sample.annot/family"))
    unique.pop.id = unique(pop.id)
    if(colr == "NA"){
	nCol = length(unique.pop.id)
    	qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
	##generate random color vector
	col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
	pop.colors=sample(col_vector, nCol)
    }
    else{
	    ##take colour names from the user provided file
	    pop.colors = fileToColMap(colr)
    }
    jpeg(jpgOut,width=6,height=6,unit='in',res=300)
    print({ggplot(tab,aes(x=EV1,y=EV2,colour=pop.id))+geom_point(size=1)+scale_colour_manual(values=pop.colors)+theme(legend.key.height= unit(0.05, 'in'),
        legend.key.width= unit(0.05, 'in'),legend.text = element_text(size=4))+guides(colour = guide_legend(ncol = 1))})
    dev.off()
    write.table(tab,eigenvectOut,sep="\t",row.names=FALSE,quote=FALSE)
    write.table(tab1,varpropOut,sep="\t",row.names=FALSE,quote=FALSE)
    }

fileToColMap = function(colrF){
	##separate vector for popname (first col) and color (second col)
	popVec = c()
	colorVec = c()
	con = file(colrF, "r")
	on.exit(close(con))
  	while ( TRUE ) {
    	line = readLines(con, n = 1)
    	if ( length(line) == 2 ) {
        lineSplit = strsplit(line, " +")[[1]]
        popVec[length(popVec)+1] = lineSplit[1]
        colorVec[length(colorVec)+1] = lineSplit[2]
        }
	pop.colors = setNames(colorVec, popVec)
	return (pop.colors)
    }
}

option_list = list(
		     make_option(c("-b", "--bed"), type="character", default=NULL, 
				               help="prefix of plink bed file", metavar="character"),
             make_option(c("-C", "--chr"), type = "integer", default=NULL, help="total number of autosomal chromosome", metavar= "character"),
		       make_option(c("-c", "--colr"), type="character", default="NA", 
				                 help="file name describing popname (column1) and color (column2) [default= %default], the columnns should be space separated", metavar="character")
		       ); 

opt_parser = OptionParser(option_list=option_list);

opt = parse_args(opt_parser);

if (is.null(opt$bed)){
  print_help(opt_parser)
  stop("At least two arguments must be supplied(-b and -C)", call.=FALSE)
}

runPCA(opt$bed, opt$chr, opt$colr)
