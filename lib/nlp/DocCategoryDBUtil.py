# -*- coding: utf-8 -*-

from MySQLWrapper import MySQLWrapper

# MySQLWrapperの初期化
def init_mysql():
    # データのロード
    mysql = MySQLWrapper()
    try:
        mysql.connect()
    except Exception as e:
        print("connection error")
        print(e.args)
        import sys
        sys.exit(1)

    return mysql

# DocCategoryTypeのid取得
def get_category_type_id_from_db(mysql, category_type_name_en):
    sql_cmd = "select id from doc_category_types where doc_category_types.name_en = '%s'" % (category_type_name_en)
    return mysql.exec_sql_cmd(sql_cmd)[0][0]

# 指定idのDocCategoryTypeの単語数取得
def get_word_num_from_db(mysql, category_type_id):
    sql_cmd = "select count(*) from words where doc_category_type_id = %d" % (category_type_id)
    return mysql.exec_sql_cmd(sql_cmd)[0][0]
# 指定idのDocCategoryTypeに対して、カテゴリーの配列インデックスからデータベース情報DocCategoryのIDを取得
def get_category_name_en_from_db(mysql, category_type_id, category_array_id):
    sql_cmd = "select id from doc_categories where doc_categories.doc_category_type_id = %d order by id" % (category_type_id)
    results = mysql.exec_sql_cmd(sql_cmd)
    category_id = results[category_array_id][0]
    sql_cmd = "select name_en from doc_categories where doc_categories.id = %d" % (category_id)
    return mysql.exec_sql_cmd(sql_cmd)[0][0]
