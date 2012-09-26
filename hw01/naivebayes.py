#!/usr/bin/env python

"""
naive bayes implementation for ml701 class.
willie neiswanger, 09/2012.
"""

import csv
import numpy as np
import random as ran
import math
from math import log

n = None
d = None

def parseData(fileString=None):
    if fileString==None: fileString = 'hw1-data.txt'
    data = np.array(list(csv.reader(open(fileString,"rb"),delimiter=',')))
    X = data[:,1:].astype('float')
    Y = data[:,0]
    global n; global d
    n = float(X.shape[0]); d = float(X.shape[1])
    return X,Y

def getTrainTest(X,Y,numTrain):
    indTrain = ran.sample(xrange(X.shape[0]), int(math.floor((2/3.)*X.shape[0])))
    indTrainSub = ran.sample(indTrain, numTrain)
    indTest = [i for i in xrange(X.shape[0]) if not(i in indTrain)]
    XTrain = X[indTrainSub,:]
    YTrain = Y[indTrainSub,:]
    XTest = X[indTest,:]
    YTest = Y[indTest,:]
    return XTrain,YTrain,XTest,YTest

def trainModel(XTrain,YTrain):
    model = {}
    subA = XTrain[np.where(YTrain=='A')[0],:]
    subB = XTrain[np.where(YTrain=='B')[0],:]
    try: model['A'] = ((subA.shape[0]+1)/n, {x:{i+1:np.where(subA[:,i]==x)[0].shape[0]/float(subA.shape[0]) for i in range(int(d))} for x in range(1,4)})
    except: model['A'] = (0, {x:{i+1:0 for i in range(int(d))} for x in range(1,4)})
    try: model['B'] = ((subB.shape[0]+1)/n, {x:{i+1:np.where(subB[:,i]==x)[0].shape[0]/float(subB.shape[0]) for i in range(int(d))} for x in range(1,4)})
    except: model['B'] = (0, {x:{i+1:0 for i in range(int(d))} for x in range(1,4)})
    return model
 
def testModel(model,XTest,YTest):
    try: predA = [log(model['A'][0]) + sum([model['A'][1][XTest[j,i]][i+1] for i in range(int(d))]) for j in range(XTest.shape[0])]
    except: predA = [0 for j in range(XTest.shape[0])]
    try: predB = [log(model['B'][0]) + sum([model['B'][1][XTest[j,i]][i+1] for i in range(int(d))]) for j in range(XTest.shape[0])]
    except: predB = [0 for j in range(XTest.shape[0])]
    YPred = ['A' if predA[i]>=predB[i] else 'B' for i in range(len(predA))]
    return sum([1 for i in range(len(YPred)) if not(YPred[i]==YTest[i])])/float(len(YPred))
    
def doAnIter(X,Y,numTrain=10):
    XTrain,YTrain,XTest,YTest = getTrainTest(X,Y,numTrain)
    model = trainModel(XTrain,YTrain)
    return testModel(model,XTest,YTest)

def ave100Iter(X,Y,numTrain=10):
    iters = [doAnIter(X,Y,numTrain) for i in range(100)]
    return sum(iters)/float(len(iters))

def main():
    X,Y = parseData()
    acc = []
    for m in range(2,200,2):
        acc.append(ave100Iter(X,Y,m))
        print 'finished m = ', str(m)
    return acc
