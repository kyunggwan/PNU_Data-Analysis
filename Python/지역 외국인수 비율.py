# -*- coding: utf-8 -*-
"""
Created on Wed Nov 30 16:33:03 2022

@author: user
"""

import usecsv

pop = usecsv.opencsv("popSeoul.csv")
pop = usecsv.switch(pop)


new = [["구", "한국인","외국인수","외국인 비율(%)"]]

for i in pop:
    try:
        f = round(i[2]/(i[1]+i[2])*100,1)
        print(f"구이름 : {i[0]} \t 외국인 비율{f}")
        if f>3:
            new.append([i[0],i[1],i[2],f])
    except:
        pass
    
usecsv.writeCsv("newPop.csv", new)