import sys

##implement the help options


def createPar(pedPrefix, numChrom, numT, paramFile):
    paramList = [
        "indivname:",
        "snpname:",
        "genotypename:",
        "numchrom:",
        "evecoutname:",
        "evaloutname:",
        "numthreads:",
    ]
    with open(pedPrefix + ".smartpca.par", "w") as dest:
        dest.write("indivname: " + pedPrefix + ".ind" + "\n")
        dest.write("snpname: " + pedPrefix + ".snp" + "\n")
        dest.write("genotypename: " + pedPrefix + ".eigenstratgeno" + "\n")
        dest.write("numchrom: " + numChrom + "\n")
        dest.write("evecoutname: " + pedPrefix + ".evec" + "\n")
        dest.write("evaloutname: " + pedPrefix + ".eval" + "\n")
        dest.write("numthreads: " + numT + "\n")
        if paramFile != "none":
            with open(paramFile) as source:
                for line in source:
                    lineL = line.rstrip().split()
                    if not lineL[0] in paramList:
                        dest.write(line)


if __name__ == "__main__":
    createPar(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
