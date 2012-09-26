#!/usr/bin/env python

"""
hw01 section 3.4.(a)-(e) implementation for ml701 class.
willie neiswanger, 09/2012.
"""

import naivebayes as nb
import logisticreg as lr
import matplotlib.pyplot as plt

nb_acc = nb.main()
lr_acc = lr.main()
plt.plot(range(2,200,2),nb.main(),label='naive bayes')
plt.plot(range(2,200,2),lr.main(),label='logistic regression')
plt.legend()
plt.xlabel('Size of Training Set')
plt.ylabel('Classification Error')
plt.savefig('hw01plot.png')
plt.show()
