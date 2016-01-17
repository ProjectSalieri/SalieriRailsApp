# -*- coding: utf-8 -*-

import MySQLdb
import json
import os

class MySQLWrapper:

    def __init__(self):
        pass

    def connect(self):
        # Openshift対応
        if os.getenv("OPENSHIFT_MYSQL_DB_HOST") != None:
            sql_info = {
                "db_name" : os.getenv("OPENSHIFT_APP_NAME"),
                "user_name" : os.getenv("OPENSHIFT_MYSQL_DB_USERNAME"),
                "password" : os.getenv("OPENSHIFT_MYSQL_DB_PASSWORD"),
                "host" : os.getenv("OPENSHIFT_MYSQL_DB_HOST")
            }
            return self._connect_by_info(sql_info)
        else:
            return self._connect_by_json()

    # MySQLへコネクト
    # @param info { "db_name" : "", "user_name" : "", "password" : "", "host" : " }
    def _connect_by_info(self, info):
        try:
            self.connection = MySQLdb.connect(
            db=mysql_info["db_name"],
            user=mysql_info["user_name"],
            passwd=mysql_info["password"],
            host=mysql_info["host"])
        except Exception as e:
            raise e
        return True

    def _connect_by_json(self, json_file = os.path.join( os.path.dirname(__file__), "mysql_info.json" )):
        json_content = ""
        with open(json_file, "r") as fin:
            json_content = json.loads(fin.read())
        return self._connect_by_info(json_content)

if __name__ == '__main__':
    print("MySQL test")

    print("Load MySQL login info")
    mysql_info_path = os.path.join( os.path.dirname(__file__), "mysql_info.json" )
    if os.path.exists(mysql_info_path):
        with open(mysql_info_path, "r") as fin:
            content = fin.read()
        mysql_info = json.loads(content)
        print(mysql_info)
        
    mysql = MySQLWrapper()
    print("Start Connect")
    try:
        mysql.connect()
        connection = mysql.connection
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
