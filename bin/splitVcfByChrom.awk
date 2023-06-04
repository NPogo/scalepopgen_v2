#!/usr/bin/awk -f
BEGIN{
    FS="\t"
    OFS="\t"
    headerStop=0 
}
{
    if($0~/#/){
        record[NR]=$0
        chrom[0]
        if($0~/#CHROM/){
            headerStop=NR
            }
        next
        }
    else
        if(!($1 in chrom)){
            for(i=1;i<=headerStop;i++){
                rec=record[i]
                if(rec~/#contig/){
                    match(rec,/(##contig=<ID=)([^,]+)(.*)/,a)
                    if(a[2]==$1){
                        print rec>>$1".split.vcf"
                    }
                    else
                        continue
                }
                else
                    print rec>>$1".split.vcf"
                    chrom[$1]
            }
            print>>$1".split.vcf"
        }
        else{
            print>>$1".split.vcf"
        }
}
