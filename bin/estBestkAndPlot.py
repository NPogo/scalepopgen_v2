import sys
import re
import argparse
import numpy as np
from collections import OrderedDict
from scipy.signal import argrelextrema
import matplotlib.pyplot as plt

def mainFunction(typeMinima, fileList):
    cvValueDict = OrderedDict()
    cvValueListSorted = []
    kValueListSorted = []
    for fileName in fileList:
        with open(fileName) as source:
            for line in source:
                if line.startswith("CV"):
                    line = line.rstrip()
                    pattern = re.compile("CV error \(K=([0-9]+)\):\s+(.*)")
                    match = re.findall(pattern, line)
                    kValue = int(match[0][0])
                    cvValue = float(match[0][1])
                    cvValueDict[kValue] = cvValue
    for i in range(min(list(cvValueDict.keys())),max(list(cvValueDict.keys()))+1):
        kValueListSorted.append(i)
        cvValueListSorted.append(cvValueDict[i])
    
    try:
        localMinimaList = list(argrelextrema(np.array(cvValueListSorted), np.less))[0]
        if typeMinima == "local":
            minimaIdx = localMinimaList[0]
        elif typeMinima == "global":
             minimaIdx=cvValueListSorted.index(min([cvValueListSorted[i] for i in localMinimaList]))
        bestK = kValueListSorted[ minimaIdx ]
        bestCv = cvValueListSorted[ minimaIdx ]
        plt.plot(kValueListSorted, cvValueListSorted)
        plt.plot(bestK, bestCv, 'g*')
        plt.xticks(np.arange(min(kValueListSorted), max(kValueListSorted)+1, 1.0))
        plt.xlabel("K-values for admixture analysis")
        plt.ylabel("CV error values")
        plt.savefig('cvErrorPlot_bestK'+str(bestK)+".png",dpi = 300)
    except:
        print("the function could not find " + typeMinima +" minima, use even greater K-values than "+str(max(kValueListSorted))+" for admixture analysis")
        sys.exit(1)
if __name__ == "__main__":
    mainFunction(sys.argv[1], sys.argv[2:])
