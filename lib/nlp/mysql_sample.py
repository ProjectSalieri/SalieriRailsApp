import MySQLdb
import json
import os

if __name__ == '__main__':
    print("MySQL test")

    print("Load MySQL login info")
    mysql_info_path = os.path.join( os.path.dirname(__file__), "mysql_info.json" )
    with open(mysql_info_path, "r") as fin:
        content = fin.read()
    mysql_info = json.loads(content)
        
    print("Start Connect")
    try:
        connection = MySQLdb.connect(db=mysql_info["db_name"],user=mysql_info["user_name"], passwd=mysql_info["password"])
    except Exception as e:
        print("connection error")
        print(e.args)
        import sys
        sys.exit(1)
    cursor = connection.cursor()
    sql_cmd = "select * from twitter_accounts"
    print("Execute SQL Command")
    cursor.execute(sql_cmd)
    results = cursor.fetchall()
    for result in results:
        print(result)

    print("cursor close")
    cursor.close()
    print("connection close")
    connection.close()

    print("end")
