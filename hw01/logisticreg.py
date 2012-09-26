#!/usr/bin/env python

"""
logistic regression implementation for ml701 class.
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
    X = np.hstack([np.array([1]*X.shape[0])[np.newaxis].T, X])
    Y = data[:,0]
    Y = np.array([1 if i=='A' else 0 for i in Y])
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
    w = np.array([0.]*int(d))
    step = 0.0001; eps = 100; numsteps = 0
    while eps>0.001:
        wNew = np.array([ w[j] + step*sum([(YTrain[i] - (1/float(1 + math.exp(-np.dot(w,XTrain[i,:])))))*XTrain[i,j] for i in range(XTrain.shape[0])]) for j in range(int(d))])
        eps = np.linalg.norm(wNew - w)
        w = wNew
    return w
 
def testModel(w,XTest,YTest):
    predA = [(1/float(1 + math.exp(-np.dot(w,XTest[i,:])))) for i in range(XTest.shape[0])]
    predB = [1 - (1/float(1 + math.exp(-np.dot(w,XTest[i,:])))) for i in range(XTest.shape[0])]
    YPred = np.array([1 if predA[i]>=predB[i] else 0 for i in range(len(predA))])
    return sum([1 for i in range(len(YPred)) if not(YPred[i]==YTest[i])]) / float(len(YPred))

def processThroughTrain(X,Y,numTrain=5):
    XTrain,YTrain,XTest,YTest = getTrainTest(X,Y,numTrain)
    return trainModel(XTrain,YTrain)

def doAnIter(X,Y,numTrain=10):
    XTrain,YTrain,XTest,YTest = getTrainTest(X,Y,numTrain)
    w = trainModel(XTrain,YTrain)
    return testModel(w,XTest,YTest)

def ave100Iter(X,Y,numTrain=10):
    iters = [doAnIter(X,Y,numTrain) for i in range(100)]
    return sum(iters)/float(len(iters))

def main():
    X,Y = parseData()
    acc = []
    print 'Logistic Regression'
    for m in range(2,200,2):
        acc.append(ave100Iter(X,Y,m))
        print 'finished m = ', str(m), '  Accuracy = ', str(acc[-1])
    return acc
