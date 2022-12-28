# -*- coding: utf-8 -*-
"""
Created on Wed Nov 30 16:57:33 2022

@author: user
"""
import usecsv, re

apt = usecsv.opencsv("apt_202211.csv")
apt = usecsv.switch(apt)

new = [["시군구","전용면적","거래금액","단지명"]]  #저장할 목록 생성

for i in apt:
    try:
        if i[5]>100 and i[8]>30000 and re.match(r'부산', i[0]): #100제곱미터, 3억이상인 매물
            print(f"{i[0]},{i[5]},{i[8]},{i[4]}")
            new.append([i[0],i[5],i[8],i[4]])   #저장할 것 append함
    except:
        pass

#파일 쓰기로 저장
usecsv.writeCsv("aptover100_lower30000.csv", new)


# 가운데 있는걸 찾는거는 search
#for i in apt:
 #   try:
#        if i[5]>120 and i[8]>30000 and re.search(r'해운대', i[0]): #120제곱미터, 3억이상인 매물
 #           print(f"{i[0]},{i[5]},{i[8]},{i[4]}")
 #   except:
 #       pass