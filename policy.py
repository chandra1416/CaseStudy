import csv
import datetime
import mysql.connector
from mysql.connector import Error
con=mysql.connector.connect(host="localhost",username="chandra",password="@chennai1",database='abc')
cur=con.cursor()
#Function for Converting string to date
def date_convert(x):
	format='%d-%b-%Y'
	datetime_object=datetime.datetime.strptime(x,format)
	h=datetime_object.date()
	#d=datetime.datetime.strftime(h,format)
	return h
# Function definition to read file and store in Table
def addDailyData(file):
	try:
		val = []
		with open(file,'r') as c:
			daily_data = csv.DictReader(c, delimiter='|')
			for row in daily_data:
				#if date is not present replace with null and if date is present as string convert  to date format
				# PolicyStartDate checking
				if len(row['PolicyStartDate']) == 0:
					PolicyStartDate = None
				else:
					PolicyStartDate = date_convert(row['PolicyStartDate'])
				# PolicyExpirationDate checking
				if len(row['PolicyExpirationDate'] )== 0:
					PolicyExpirationDate = None
				else:
					PolicyExpirationDate = date_convert(row['PolicyExpirationDate'])            
				#creating list for insert multiple records
				val.append((row['PolicyId'], row['PolicyNumber'], row['PolicYHolderName'], PolicyStartDate, PolicyExpirationDate, row['PolicyType']))
		in_qry= '''INSERT IGNORE INTO Policy(PolicyId,PolicyNumber,PolicYHolderName,PolicyStartDate,PolicyExpirationDate,PolicyType)
        VALUES (%s, %s, %s, %s, %s, %s);'''
		cur.executemany(in_qry, val)
		#commit changes
		con.commit()
	except Exception as e:
		print("Error : ", str(e))	
		con.rollback()
'
