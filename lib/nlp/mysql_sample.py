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
    host = "localhost"
    if os.getenv('OPENSHIFT_MYSQL_DB_HOST') != None:
        host = os.getenv('OPENSHIFT_MYSQL_DB_HOST')
    port = 3306
    if os.getenv('OPENSHIFT_MYSQL_DB_PORT') != None:
        port = os.getenv('OPENSHIFT_MYSQL_DB_PORT')
    mysql_info.update({"host" : host})
    mysql_info.update({"port" : port})
    print(mysql_info)
        
    print("Start Connect")
    try:
        connection = MySQLdb.connect(
            db=mysql_info["db_name"],
            user=mysql_info["user_name"],
            passwd=mysql_info["password"],
            host=mysql_info["host"])
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
