# -*- coding: utf-8 -*-

from MySQLWrapper import MySQLWrapper

# DocCategoryTypeのid取得
def get_category_type_id_from_db(mysql, name_en):
    sql_cmd = "select id from doc_category_types where doc_category_types.name_en = '%s'" % (category_type)
    return mysql.exec_sql_cmd(sql_cmd)[0][0]

# 指定idのDocCategoryTypeの単語数取得
def get_word_num_from_db(mysql, category_type_id):
    sql_cmd = "select count(*) from words where doc_category_type_id = %d" % (category_type_id)
    return mysql.exec_sql_cmd(sql_cmd)[0][0]

# 実行main
if __name__ == '__main__':

    # 学習処理
    category_type = "Genre"

    # データのロード
    mysql = MySQLWrapper()
    try:
        mysql.connect()
    except Exception as e:
        print("connection error")
        print(e.args)
        import sys
        sys.exit(1)

    # DocCategoryTypeのid取得
    category_type_id = get_category_type_id_from_db(mysql, category_type)

    # 単語数の取得
    word_num = get_word_num_from_db(mysql, category_type_id)

    # DocCategoryの取得
    sql_cmd = "select id, appear_count from doc_categories where doc_categories.doc_category_type_id = %d" % (category_type_id)
    results = mysql.exec_sql_cmd(sql_cmd)
    category_infos = []
    category_appear_count_sum = 0
    for result in results:
        info = {"id" : result[0], "appear_count" : result[1]}
        category_infos.append(info)
        category_appear_count_sum += info["appear_count"]

    # DocCategory毎にDocCategoryInfoを取得
    category_appear_count_sum = 0
    for category_info in category_infos:
        sql_cmd = "select appear_count from doc_category_infos left outer join words on words.id = doc_category_infos.word_id where doc_category_infos.doc_category_id = %d order by words.value" % (category_info["id"])
        results = mysql.exec_sql_cmd(sql_cmd)
        sum = 0
        appear_counts = []
        for result in results:
            sum += result[0]
            appear_counts.append(result[0])
        category_info["count_info"] = { "sum" : sum, "appear_counts" : appear_counts }

    # パラメータ計算


    mysql.close()
