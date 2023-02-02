# #### 5. weather 테이블

# In[1]:


import pandas as pd
import pymysql


# In[2]:


## 날씨정보
weather = pd.read_csv('./car.csv', encoding = 'cp949')
weather.reset_index(drop = True)


# In[3]:


# 컬럼 리스트 생성
car_num = weather.iloc[:,0].to_list()
distance = weather.iloc[:,1].to_list()
distance_cum = weather.iloc[:,2].to_list()
speed_av = weather.iloc[:,3].to_list()
speed_max= weather.iloc[:,4].to_list()
operating_time = weather.iloc[:,5].to_list()
stop_num=weather.iloc[:,6].to_list()
stop_time =weather.iloc[:,7].to_list()
stop_rate = weather.iloc[:,8].to_list()
drive_time = weather.iloc[:,9].to_list()
rpm_max = weather.iloc[:,10].to_list()
rpm_av = weather.iloc[:,11].to_list()

# In[4]:


list_sqlData = []
# sql문 생성
for i in range(len(weather)) :
    a = car_num[i], distance[i], distance_cum[i], speed_av[i], speed_max[i], operating_time[i], stop_num[i],stop_time[i],stop_rate[i], drive_time[i],rpm_max[i],rpm_av[i]
    list_sqlData.append(a)


# In[13]:


# Connection and Cursor
import pymysql
# conn = pymysql.connect(host='database-1.cd1ds11df3el.ap-northeast-2.rds.amazonaws.com',
#                                      database='db1',
#                                      user='admin',
#                                      password='tigertiger')
try:
    with conn.cursor() as cursor:
        sql = 'INSERT INTO car (car_num, distance, distance_cum, speed_av, speed_max, operating_time, stop_num, stop_time, stop_rate, drive_time, rpm_max, rpm_av) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)'
        cursor.executemany(sql, list_sqlData)
    conn.commit()
finally:
    conn.close()


# In[ ]:





# In[ ]:




