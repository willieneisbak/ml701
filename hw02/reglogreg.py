#!/usr/bin/env python

"""
regularized logistic regression implementation for ml701 class.
willie neiswanger, 10/2012.
"""

import csv
import numpy as np
import random as ran
import math
from math import log

X = None; Y = None; n = None 
XTest = None; YTest = None; nTest = None
d = None

def makeXandY(data):
    X = data[:,1:].astype('float') # change strings in X numpy matrix to floats
    X = np.hstack([np.array([1]*X.shape[0])[np.newaxis].T, X]) # add coefficient=1 to first column of data
    Y = data[:,0]
    Y = Y.astype('float') # change strings in Y numpy matrix to floats
    return X,Y

def parseData():
    trainFileString = 'hw2-train.csv'; testFileString = 'hw2-test.csv'
    traindata = np.array(list(csv.reader(open(trainFileString,"Ub"),delimiter=',')))
    testdata = np.array(list(csv.reader(open(testFileString,"Ub"),delimiter=',')))
    global n,X,Y,nTest,XTest,YTest,d
    X,Y = makeXandY(traindata); XTest,YTest = makeXandY(testdata)
    n = float(X.shape[0]); nTest = float(XTest.shape[0])
    d = float(X.shape[1])

def trainModel(XTrain,YTrain,reg=0):
    w = np.array([0.]*int(d))
    step = 0.0001; eps = 100; numsteps = 0
    while eps>0.001:
        wNew = w + step*(np.dot(XTrain.T, YTrain - 1./(1. + np.exp(-1*np.dot(XTrain,w)))) - (reg*w))
        eps = np.linalg.norm(wNew - w)
        w = wNew
    return w
 
def testModel(w,XTest,YTest):
    #note: for loo (ie only one test data point)
    predA = 1/float(1 + math.exp(-np.dot(w,XTest)))
    predB = 1 - (1/float(1 + math.exp(-np.dot(w,XTest))))
    YPred = 1 if predA >= predB else 0
    return int(YPred==YTest)

def testModel_fullData(w,XTest,YTest):
    accVec = []
    for i in range(XTest.shape[0]):
        accVec.append(testModel(w,XTest[i,:],YTest[i]))
    return sum(accVec) / float(len(accVec))

def crossValidation(reg):
    wVec = []
    errVec = []
    for i in range(X.shape[0]):
        XTest = X[i,:]
        YTest = Y[i]
        XTrain = np.delete(X,i,0)
        YTrain = np.delete(Y,i)
        w = trainModel(XTrain,YTrain,reg)
        err = testModel(w,XTest,YTest)
        wVec.append(w)
        errVec.append(err)
        accuracy = sum(errVec)/float(len(errVec))
    return accuracy 
        
def main():
    parseData()
    print 'Regularized Logistic Regression'
    accVec = []
    for i in range(51):
        accVec.append(crossValidation(i))
        print 'Lambda = %d, mean l.o.o. accuracy = %f' % (i, accVec[-1])
    accVec = np.array(accVec)
    #bestLambda = np.argmax(accVec)
    bestLambdas = np.where(accVec==np.amax(accVec)) 
    bestLambda = np.max(bestLambdas)
    w = trainModel(X,Y,bestLambda)
    trainAcc = testModel_fullData(w,X,Y)
    testAcc = testModel_fullData(w,XTest,YTest)
    print 'Best Lambdas: ' + map(str,bestLambdas)[0]
    print 'Chosen Lambda = %d' % (bestLambda)
    print 'Training Accuracy = %f. Training Error = %f' % (trainAcc, 1-trainAcc)
    print 'Testing Accuracy = %f. Testing Error = %f' % (testAcc, 1-testAcc)
    return accVec,bestLambdas,w,trainAcc,testAcc
