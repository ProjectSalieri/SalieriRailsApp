# -*- coding: utf-8 -*-

import sys
import os
import pickle

import numpy as np

from MySQLWrapper import MySQLWrapper
from MultinominalModelNaiveBayes import MultinominalModelNaiveBayes
from DocCategoryDBUtil import *

class CategoryData:

    def __init__(self):
        self.word_num = 0
        self.document_num = 0
        self.category_num = 0
        self.category_appear_counts = []		# 各カテゴリの出現回数
        self.word_appear_count_sum = [] 	# 各カテゴリの単語出現の総回数
        self.word_appear_counts = []			# 各カテゴリ毎の単語出現回数

def create_picle_path():
    return os.path.join(os.path.dirname(__file__), "MultinominalModelNaiveBayes.pickle")

# 指定idのDocCategoryTypeのカテゴリ情報を生成
def create_category_data_from_db(mysql, category_type_id):
    category_data = CategoryData()

    # 単語数の取得
    word_num = get_word_num_from_db(mysql, category_type_id)
    category_data.word_num = word_num

    sql_cmd = "select id, appear_count from doc_categories where doc_categories.doc_category_type_id = %d order by id" % (category_type_id)
    results = mysql.exec_sql_cmd(sql_cmd)
    category_ids = []
    document_num = 0
    for result in results:
        category_ids.append(result[0])
        appear_count = result[1]
        document_num += appear_count
        category_data.category_appear_counts.append(appear_count)
    category_data.document_num = document_num
    category_data.category_num = len(category_ids)

    for category_id in category_ids:
        sql_cmd = "select appear_count from doc_category_infos"
        sql_cmd += " left outer join words on words.id = doc_category_infos.word_id"
        sql_cmd += " where doc_category_infos.doc_category_id = %d" % (category_id)
        sql_cmd += " order by words.value"
        results = mysql.exec_sql_cmd(sql_cmd)
        sum = 0
        appear_counts = []
        for result in results:
            sum += result[0]
            appear_counts.append(result[0])
        category_data.word_appear_count_sum.append(sum)
        category_data.word_appear_counts.append(appear_counts)

    return category_data

def learn(category_type):
    # データのロード
    mysql = init_mysql()

    # DocCategoryTypeのid取得
    category_type_id = get_category_type_id_from_db(mysql, category_type)

    # DocCategoryInfoの情報を取得
    category_data = create_category_data_from_db(mysql, category_type_id)

    mysql.close()

#    print(category_data.document_num)
#    print(category_data.category_appear_counts)
#    print(category_data.word_appear_count_sum)
#    print(category_data.word_appear_counts)

    # パラメータ計算
    model = MultinominalModelNaiveBayes(category_data.word_num, category_data.category_num)
    for category_id in range(category_data.category_num):
        # 各カテゴリの出現確率
        numerator = category_data.category_appear_counts[category_id] + 1.0
        denominator = category_data.document_num + category_data.category_num
        model.priors[category_id] = numerator / denominator
        
        # 各単語の出現確率
        multinominal_model = model.models[category_id]
        word_appear_count_sum = category_data.word_appear_count_sum[category_id]
        for w_idx in range(len(category_data.word_appear_counts[category_id])):
            w_appear_cnt = category_data.word_appear_counts[category_id][w_idx]
            numerator = w_appear_cnt + 1.0
            denominator = word_appear_count_sum + category_data.word_num
            multinominal_model.set(w_idx, numerator/denominator)

    # シリアライズ
    file_path = create_picle_path()
    with open(file_path, "wb") as fout:
        pickle.dump(model, fout)    

def create_model():
    model = None
    file_path = create_picle_path()
    with open(file_path, "rb") as fin:
        model = pickle.load(fin)
    return model


# 実行main
if __name__ == '__main__':

    argvs = sys.argv

    cmd = None
    category_type = "Genre"
    input_data = np.array([])
    is_exist_opt = False
    for i in range(len(argvs)):
        if i == 0:
            continue

        if is_exist_opt:
            is_exist_opt = False
            continue

        if argvs[i] == "--learn":
            cmd = "learn"
        elif argvs[i] == "--predict":
            cmd = "predict"
        elif argvs[i] == "--category_type":
            category_type = argvs[i+1]
            is_exist_opt = True
        else:
            input_data = np.append(input_data, [(int)(argvs[i])])

    pickle_path = create_picle_path()
    is_exist_pickle = os.path.exists(pickle_path)

    if cmd == "learn" or is_exist_pickle == False:
        learn(category_type)

    if cmd == "predict":
        model = create_model()
        category_array_id = model.decide(input_data)
        mysql = init_mysql()
        category_type_id = get_category_type_id_from_db(mysql, category_type)
        print(get_category_name_en_from_db(mysql, category_type_id, category_array_id))
