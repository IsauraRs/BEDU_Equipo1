from random import *

nombres=['Alex','David','Isaura','Kevin']

while len(nombres):
    rand=randint(0,len(nombres)-1)
    print(nombres.pop(rand))
    
