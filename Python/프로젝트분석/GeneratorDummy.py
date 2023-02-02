import time
import pandas as pd
import pymysql
from sqlalchemy import create_engine
import configparser


df = pd.read_csv("./totalmain.csv", encoding='cp949')


date = df.iloc[:,0].to_list()
model_name = df.iloc[:,1].to_list()
car_type = df.iloc[:,2].to_list()
car_num = df.iloc[:,3].to_list()
business_num = df.iloc[:,4].to_list()
driver_code = df.iloc[:,5].to_list()
daily_distance = df.iloc[:,6].to_list()

cum_distance = df.iloc[:,7].to_list()
information_date = df.iloc[:,8].to_list()
car_speed = df.iloc[:,9].to_list()
RPM = df.iloc[:,10].to_list()
brake_signal = df.iloc[:,11].to_list()
car_location_GPS_X = df.iloc[:,12].to_list()
car_location_GPS_Y = df.iloc[:,13].to_list()
Global_Positioning_System_GPS_azimuth = df.iloc[:,14].to_list()
accelerationVx = df.iloc[:,15].to_list()
accelerationVy = df.iloc[:,16].to_list()
status_code = df.iloc[:,17].to_list()
RPMS = df.iloc[:,18].to_list()
ACC = df.iloc[:,19].to_list()
FS = df.iloc[:,20].to_list()
RPMSR = df.iloc[:,21].to_list()
ACCR = df.iloc[:,22].to_list()
SRA = df.iloc[:,23].to_list()

list_sqlData = []

# sql문 생성

for i in range(len(df)) :
    a = date[i], model_name[i] ,car_type[i],car_num[i],business_num[i],driver_code[i], daily_distance[i], cum_distance[i],information_date[i],car_speed[i],RPM[i],brake_signal[i],
    car_location_GPS_X[i],car_location_GPS_Y[i],Global_Positioning_System_GPS_azimuth[i],accelerationVx[i],accelerationVy[i],status_code[i],RPMS[i],ACC[i],FS[i],
    RPMSR[i],ACCR[i],SRA[i]
    list_sqlData.append(a)
# tideLevel = weather.iloc[:,4].to_list()


# In[4]:

# list_sqlData = []
# sql문 생성

# for i in range(len(total)) :

#     a = date[i], model_name[i] ,car_type[i],car_num[i],business_num[i],
#     driver_code[i], daily_distance[i],cum_distance[i],information_date[i], 
#     car_speed[i], RPM[i], brake_signal[i], car_location_GPS_X[i], car_location_GPS_Y[i], 
#     Global_Positioning_System_GPS_azimuth[i], accelerationVx[i], accelerationVy[i], status_code[i],
#     RPMS[i], ACC[i], FS[i], RPMSR[i], ACCR[i], SRA[i]  
#     list_sqlData.append(a)



# In[13]:
# date, model_name, car_type,	car_num, business_num, driver_code,	daily_distance,	cum_distance, information_date,	car_speed,	RPM, brake_signal, car_location_GPS_X, car_location_GPS_Y, Global_Positioning_System_GPS_azimuth, accelerationVx, accelerationVy, status_code, RPMS, ACC, FS, RPMSR, ACCR, SRA


# Connection and Cursor
import pymysql
conn = pymysql.connect(host='database-1.cd1ds11df3el.ap-northeast-2.rds.amazonaws.com',
                                     database='p1',
                                     user='admin',
                                     password='tigertiger')
try:

    with conn.cursor() as cursor:
        sql = 'INSERT INTO total (date, model_name, car_type, car_num, business_num, driver_code, daily_distance, cum_distance, information_date, car_speed, RPM, brake_signal, car_location_GPS_X, car_location_GPS_Y, Global_Positioning_System_GPS_azimuth, accelerationVx, accelerationVy, status_code, RPMS, ACC, FS, RPMSR, ACCR, SRA) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)'
        cursor.executemany(sql, list_sqlData)
    conn.commit()
finally:
    conn.close()


# In[ ]:





# In[ ]:




