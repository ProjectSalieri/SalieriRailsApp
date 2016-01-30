# -*- coding: utf-8 -*-

from MySQLWrapper import MySQLWrapper

# 実行main
if __name__ == '__main__':

    # 学習処理

    # データのロード
    mysql = MySQLWrapper()
    try:
        mysql.connect()
    except Exception as e:
        print("connection error")
        print(e.args)
        import sys
        sys.exit(1)

    results = mysql.exec_sql_cmd("select * from doc_category_types")
    for result in results:
        for i in result:
            print(i)

    mysql.close()
