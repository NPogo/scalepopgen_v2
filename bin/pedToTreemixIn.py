import sys
import argparse
import re
import gzip


def mainFunction(pedIn, treemixOut):
    recordDict = {}
    markerDList = []
    with open(pedIn) as source:
        for line in source:
            line = line.rstrip().split()
            if line[0] not in recordDict:
                recordDict[line[0]] = []
            genoRecords = line[6:]
            for i in range(0,len(genoRecords),2):

