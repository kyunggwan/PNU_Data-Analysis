import pandas as pd
import pymysql

## 정보
data = pd.read_csv('./마린소프트분석/데이터_전처리_파일.csv', encoding = 'cp949')
data.reset_index(drop = True)

# 컬럼 리스트 생성
invoice = data.iloc[:,0].to_list()
num = data.iloc[:,1].to_list()
subjects = data.iloc[:,2].to_list()
machinery = data.iloc[:,3].to_list()
Assembly = data.iloc[:,4].to_list()
item = data.iloc[:,5].to_list()
part1 = data.iloc[:,6].to_list()
part2 = data.iloc[:,7].to_list()
key1 = data.iloc[:,8].to_list()
key2 = data.iloc[:,9].to_list()
leadtime = data.iloc[:,10].to_list()
billing_amount = data.iloc[:,11].to_list()
esti = data.iloc[:,12].to_list()
esti_quantity = data.iloc[:,13].to_list()
currency = data.iloc[:,14].to_list()
esti_unit_price = data.iloc[:,15].to_list()
order_num = data.iloc[:,16].to_list()
clients = data.iloc[:,17].to_list()
orders = data.iloc[:,18].to_list()
order_quantity = data.iloc[:,19].to_list()
order_amount = data.iloc[:,20].to_list()
DT = data.iloc[:,21].to_list()
non_stock = data.iloc[:,22].to_list()
ware = data.iloc[:,23].to_list()
ware_input = data.iloc[:,24].to_list()
control_no = data.iloc[:,25].to_list()
warehouse = data.iloc[:,26].to_list()
ware_release = data.iloc[:,27].to_list()
ware_output = data.iloc[:,28].to_list()
vessel = data.iloc[:,29].to_list()
carrier = data.iloc[:,30].to_list()
vessel_input = data.iloc[:,31].to_list()
vessel_in_quantity = data.iloc[:,32].to_list()
complete = data.iloc[:,33].to_list()





list_sqlData = []
# sql문 생성
for i in range(len(data)) :
    a = invoice [i], num [i], subjects [i], machinery [i], Assembly [i], item [i], part1 [i], part2 [i], key1 [i], key2 [i],leadtime [i],billing_amount [i], esti[i], esti_quantity  [i], currency  [i], esti_unit_price  [i], order_num  [i], clients  [i], orders  [i], order_quantity  [i], order_amount  [i], DT[i], non_stock[i], ware [i], ware_input [i], control_no [i], warehouse [i], ware_release [i], ware_output [i], vessel [i], carrier [i], vessel_input [i], vessel_in_quantity [i], complete [i]
    list_sqlData.append(a)


conn = pymysql.connect(host='database-1.cd1ds11df3el.ap-northeast-2.rds.amazonaws.com',
                                     database='ship',
                                     user='admin',
                                     password='tigertiger')
try:
    with conn.cursor() as cursor:
        sql = 'INSERT INTO raw_data (invoice , num , subjects , machinery , Assembly , item , part1 , part2 , key1 , key2 , leadtime , billing_amount, esti , esti_quantity , currency , esti_unit_price , order_num , clients , orders , order_quantity , order_amount , DT , non_stock , ware , ware_input , control_no , warehouse , ware_release , ware_output , vessel , carrier , vessel_input , vessel_in_quantity , complete) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)'
        cursor.executemany(sql, list_sqlData)
    conn.commit()
finally:
    conn.close()


