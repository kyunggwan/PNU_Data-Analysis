# #### 5. weather 테이블

# In[1]:


import pandas as pd
import pymysql


# In[2]:


## 날씨정보
weather = pd.read_csv('C:\/Users/user/Desktop/항만운영정보시스템data/ModelingDataset/weather.csv', encoding = 'cp949', index_col = 0)
weather.reset_index(drop = True)


# In[3]:


# 컬럼 리스트 생성
obsId = weather.iloc[:,0].to_list()
time = weather.iloc[:,1].to_list()
temp = weather.iloc[:,7].to_list()
pressure = weather.iloc[:,8].to_list()
windDirec= weather.iloc[:,6].to_list()
windSpeed = weather.iloc[:,5].to_list()
obsLat=weather.iloc[:,2].to_list()
obsLon =weather.iloc[:,3].to_list()
tideLevel = weather.iloc[:,4].to_list()


# In[4]:


list_sqlData = []
# sql문 생성
for i in range(len(weather)) :
    a = obsId[i], time[i] ,temp[i],pressure[i],windDirec[i],windSpeed[i], obsLat[i],obsLon[i],tideLevel[i]
    list_sqlData.append(a)


# In[13]:


# Connection and Cursor
import pymysql
conn = pymysql.connect(host='jkm1.cdoztymfmdwr.ap-northeast-2.rds.amazonaws.com',
                                     database='db이름',
                                     user='admin',
                                     password='')
try:
    with conn.cursor() as cursor:
        sql = 'INSERT INTO weather (obsId, time, temp, pressure, windDirec, windSpeed, obsLat, obsLon, tideLevel) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)'
        cursor.executemany(sql, list_sqlData)
    conn.commit()
finally:
    conn.close()


# In[ ]:





# In[ ]:




