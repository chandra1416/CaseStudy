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
