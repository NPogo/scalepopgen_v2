import sys
from collections import OrderedDict

def mainFunction(inputLogFiles):
	kValueDict = OrderedDict()
	with open("pongInput.map","w") as dest:
		for fileName in inputLogFiles:
    			fileName = fileName.split(".")
    			kValue = int(fileName[1])
    			recordList = ["run"+str(kValue)+"\t"+str(kValue)+"\t"+fileName[0]+"."+fileName[1]+".Q"]
    			kValueDict[kValue] = recordList[:]
		kValueList = list(kValueDict.keys())
		sortedkValList = sorted(kValueList)
		checkOrderList = ["err" if (sortedkValList[i]-sortedkValList[i-1])>1 else "ok" for i in range(1,len(sortedkValList))]
		if "err" in checkOrderList:
			print("k values are not consecutives, check which K value has not generated ADMIXTURE Q file")
			sys.exit(1)
		else:
			for k in sortedkValList:
    				kRecordList = kValueDict[k]
    				dest.write("\t".join(kRecordList))
    				dest.write("\n")

if __name__ == "__main__":
    mainFunction(sys.argv[1:])
