import sys

def main(pedPrefix, tool, numChrom, popComb):
    if tool == "convertf":
        with open(pedPrefix+".pedToEigenstraat.par","w") as dest:
            dest.write("genotypename: "+ pedPrefix+".1.ped"+"\n")
            dest.write("snpname: "+ pedPrefix+".map"+"\n")
            dest.write("indivname: "+ pedPrefix+".1.ped"+"\n")
            dest.write("outputformat: EIGENSTRAT"+"\n")
            dest.write("genotypeoutname: "+pedPrefix+".eigenstratgeno"+"\n")
            dest.write("snpoutname: "+pedPrefix+".snp"+"\n")
            dest.write("indivoutname: "+ pedPrefix+".ind"+"\n")
            dest.write("familynames: NO"+"\n")
    if tool == "qp3pop":
        with open(pedPrefix+".qp3Pop.par","w") as dest:
            dest.write("indivname: "+ pedPrefix+".ind"+"\n")
            dest.write("snpname: "+pedPrefix+".snp"+"\n")
            dest.write("genotypename: "+pedPrefix+".eigenstratgeno"+"\n")
            dest.write("numChrom: "+numChrom+"\n")
            if popComb == "NA":
                dest.write("popfilename: "+pedPrefix+".qp3PopComb.txt"+"\n")
            else:
                dest.write("popfilename: "+popComb+"\n")
            
if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
