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
				# ClaimApplyDate checking
				if len(row['ClaimApplyDate']) == 0:
					ClaimApplyDate = None
				else:
					ClaimApplyDate = date_convert(row['ClaimApplyDate'])
				# ClaimServiceDate checking	
				if len(row['ClaimServiceDate']) == 0:
					ClaimServiceDate = None
				else:
					ClaimServiceDate = date_convert(row['ClaimServiceDate'])
				# ClaimCompletionDate checking
				if len(row['ClaimCompletionDate']) == 0:
					ClaimCompletionDate = None
				else:
					ClaimCompletionDate = date_convert(row['ClaimCompletionDate'])
            
				#creating list for insert multiple records
				val.append((row['PolicyId'], row['PolicyNumber'], row['ClaimID'], row['ClaimType'], ClaimApplyDate, ClaimServiceDate, row['ClaimStatus'], ClaimCompletionDate))
		in_qry= '''INSERT IGNORE INTO claims(PolicyId,PolicyNumber,ClaimID,ClaimType,ClaimApplyDate,ClaimServiceDate,ClaimStatus,ClaimCompletionDate)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s);'''
		dro='''DELETE from claims WHERE ClaimStatus ="Pending" or ClaimStatus ="Pending";'''
		cur.executemany(in_qry, val)
		cur.execute(dro)
		commit changes
		con.commit()
	except Exception as e:
		print("Error : ", str(e))
		con.rollback()
