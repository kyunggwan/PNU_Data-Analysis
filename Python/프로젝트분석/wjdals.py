import pandas as pd
import pymysql
import random

def main():
	# 입력할 db 선택
	conn = selectDB()

	try:
		with conn.cursor() as cursor:
			sql, list = selectTable()
			cursor.executemany(sql, list)
		conn.commit()
		
	finally:
		conn.close()

# 입력할 DB 선택
def selectDB():
  print("Select the Database")
  print("		1. 민경 - ship")
  print("		2. aws - ship")
  selNum = int(input("Enter the number: "))

  if selNum == 1:
    conn = pymysql.connect(host='10.125.121.204', database='ship', user='musthave', password='tiger')
  elif selNum == 2:
    conn = pymysql.connect(host='jkm1.cdoztymfmdwr.ap-northeast-2.rds.amazonaws.com', 
		database='ship', user='admin', password='administrator')

  return conn

# 입력할 테이블 선택
def selectTable():
	print("Select the Table")
	print("		1. schedules")
	print("		2. ship")
	print("		3. shiplog")
	print("		4. weather")
	selNum = int(input("Enter the number: "))

	if selNum == 1:
		sql = 'INSERT INTO schedules (num, ship_shipId, arrivalPort_arrivalName, departure, departTime) VALUES (%s, %s, %s, %s, %s)'
		# list = createSchedules()
		list = createSchedules2()
	elif selNum == 2:
		sql = 'INSERT INTO ship (shipId, shipCode, shipName, shipUse) VALUES (%s, %s, %s, %s)'
		list = createShip()
	elif selNum == 3:
		sql = ''
		# list = createShiplog()
		list = createShiplog2()
	elif selNum == 4:
		sql = 'INSERT INTO weather (obsId, time, temp, pressure, windDirec, windSpeed, obsLat, obsLon, tideLevel) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)'
		list = createWeather()

	return sql, list

# schedules 테이블에 입력할 데이터 생성
def createSchedules():
	# portmis 파일 읽어오기
	portmis = pd.read_csv('./ModelingDataset/portmis.csv', encoding = 'cp949')

	# 컬럼 리스트 생성
	shipId = portmis.loc[:,"mmsi"].to_list()
	departure = portmis.loc[:,"전출항지"].to_list()
	arrivalPort = "인천항"
	departTime = calcDepartTime(shipId)

	# 입력할 데이터 리스트 생성
	list_schedulesData = []
	for i in range(1, len(shipId)):
		data = i, shipId[i] , arrivalPort, random.choice(departure), random.choice(departTime)
		list_schedulesData.append(data)
	
	return list_schedulesData

# schedules 테이블에 입력할 데이터 생성
##230203 수기입력한 10개 선박 더미데이터
def createSchedules2():
	#csv 불러오기
	schedules = pd.read_csv('./ModelingDataset/schedulesDummy_230203.csv', encoding='cp949')
	# 컬럼 리스트 생성
	shipId = schedules.loc[:, 'shipId'].to_list()
	arrivalPort = schedules.loc[:, 'arrivalName'].to_list()
	departure = schedules.loc[:, 'departure'].to_list()
	departTime = schedules.loc[:, 'departTime'].to_list()

	# 입력할 데이터 생성
	list_schedulesData = []
	for i in range(len(shipId)):
		data = shipId[i], arrivalPort[i], departure[i], departTime[i]
		list_schedulesData.append(data)
	return list

# departTime 계산
def calcDepartTime(shipId):
	departTime = []
	for i in range(0, len(shipId)) :
		M = str(random.randint(1, 12))
		h = str(random.randint(0, 23))
		m = str(random.randint(0, 59))
		s = str(random.randint(0, 59))
		if M == '2':
			d = str(random.randint(1, 28))
		elif M == '4' or '6' or '9' or '11':
			d = str(random.randint(1, 30))
		else:
			d = str(random.randint(1, 31))
		if len(M) != 2 :
			M = "0"+M
		if len(d) != 2 :
			d = "0"+d
		if len(h) != 2 :
			h = "0"+h
		if len(m) != 2 :
			m = "0"+m
		if len(s) != 2 :
			s = "0"+s
		t = "2022"+ "-" + M + "-"+ d +" "+h + ":" + m + ":" + s
		departTime.append(t)

	return departTime

# ship 테이블에 입력할 데이터 생성
def createShip():
	# 선박정보 불러오기
  ship = pd.read_csv('./ModelingDataset/shipDummy.csv', encoding = 'cp949')
  # 중복 제거
  ship = ship.drop_duplicates(subset='shipId')
  # 컬럼 리스트 생성
  shipId = ship.loc[:,'shipId'].to_list()
  shipCode = ship.loc[:,'shipCode'].to_list()
  shipName = ship.loc[:,'shipName'].to_list()
  shipUse = ship.loc[:,'shipUse'].to_list()

  # 입력할 데이터 생성
  list_shipData = []
  for i in range(len(shipCode)) :
    data = shipId[i],shipCode[i], shipName[i], shipUse[i]
    list_shipData.append(data)
  
  return list

# shiplog 테이블에 입력할 데이터 생성
def createShiplog():
	pass

# shiplog 테이블에 입력할 데이터 생성
##230203 수기입력한 10개 선박 더미데이터
def createShiplog2():
	# csv 불러오기
	shiplog = pd.read_csv('./ModelingDataset/shipDummy.csv', encoding = 'cp949')
	# 컬럼 리스트 생성
	timeGroup = shiplog.loc[:, 'timeGroup'].to_list()
	ship_shipId = shiplog.loc[:,'shipId'].to_list()
	insertTime = shiplog.loc[:,'insertTime'].to_list()
	shipLat = shiplog.loc[:,'shipLat'].to_list()
	shipLon = shiplog.loc[:,'shipLon'].to_list()
	speed = shiplog.loc[:,'speed'].to_list()
	arrivalTime = shiplog.loc[:,'arrivalTime'].to_list()
	takeTime = shiplog.loc[:,'takeTime'].to_list()
	accuracy = shiplog.loc[:,'accuracy'].to_list()
	status = shiplog.loc[:,'status'].to_list()
	totalTakeTime = shiplog.loc[:,'totalTakeTime'].to_list()

	# 입력할 데이터 생성
	list_shiplogData = []
	for i in range(len(ship_shipId)) :
		data = timeGroup[i], ship_shipId[i], insertTime[i], shipLat[i], shipLon[i],
		speed[i], arrivalTime[i], takeTime[i], accuracy[i], status[i], totalTakeTime[i]
		list_shiplogData.append(data)

	return list_shiplogData

# weather 테이블에 입력할 데이터 생성
def createWeather():
  weather = pd.read_csv('./ModelingDataset/weather.csv', encoding = 'cp949', index_col = 0)
  weather.reset_index(drop = True)

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

  # 입력할 데이터 생성
  list_weatherData = []
  for i in range(len(weather)) :
    a = obsId[i], time[i] ,temp[i],pressure[i],windDirec[i],windSpeed[i], round(obsLat[i],6),round(obsLon[i],6),tideLevel[i]
    list_weatherData.append(a)
  return list_weatherData

main()