import mysql.connector
from mysql.connector import Error
con=mysql.connector.connect(host="localhost",username="chandra",password="@chennai1",database='dec17')
cur=con.cursor()
try:
	#truncate before inserting
	tr='''truncate claims;'''
	cur.execute(tr)
	in_clqry='''INSERT ignore INTO CLAIMS(PolicyId,ClaimID,ClaimApplyDate,ClaimServiceDate,ClaimStatus,ClaimCompletionDate)WITH cte AS (select PolicyId,ClaimID,ClaimApplyDate,ClaimServiceDate,ClaimStatus,ClaimCompletionDate,ROW_NUMBER() OVER(partition by PolicyId,claimId ORDER BY ClaimApplyDate desc,ClaimCompletionDate desc,ClaimStatus desc) row_num FROM claims_transaction ) select PolicyId,ClaimID,ClaimApplyDate,ClaimServiceDate,ClaimStatus,ClaimCompletionDate from cte where row_num =1;'''
	cur.execute(in_clqry)
	#commit changes
	con.commit()
except Exception as e:
	print("Error : ", e)
	con.rollback()
