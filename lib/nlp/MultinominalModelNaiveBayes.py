# -*- coding: utf-8 -*-

import numpy as np

from MultinominalModel import MultinominalModel

# NaiveBayes + MultinominalModel
class MultinominalModelNaiveBayes:

    # コンストラクタ
    # @param v_num 単語数
    # @param cat_num カテゴリ数
    def __init__(self, v_num, cat_num):
        self.v_num = v_num
        self.cat_num = cat_num
        self.models = [ MultinominalModel(v_num) for i in range(cat_num)]
        self.priors = np.array([0.0]*self.cat_num) # 各カテゴリ事前確率

    # 学習
    # @param data_array 多項モデル学習用データ列
    #   ex. [ { "input" : [1, 3, 2, 0, .., dim-1, ...], "label_idx" : 3 } ] inputはnumpy.array
    def learn(self, data_array):
        word_cnt_array = [ [0]*self.v_num for c in range(self.cat_num) ]
        label_cnt = [0]*self.cat_num
        for data in data_array:
            # カテゴリの頻度カウント
            label_idx = data["label_idx"]
            label_cnt[label_idx] += 1

            # 単語の頻度カウント
            for v in data["input"]:
                word_cnt_array[label_idx][v] += 1

        # 各カテゴリの事前出現確率計算
        denominator = float(len(data_array)) + self.cat_num # @note スムージングしておく
        for i in range(self.cat_num):
            self.priors[i] = (label_cnt[i]+1.0) / denominator

        # 各カテゴリ毎にパラメータ計算
        for c in range(self.cat_num):
            sum = 0
            for word_cnt in word_cnt_array[c]:
                sum += word_cnt
            denominator = float(sum) + self.v_num # @note スムージング

            for v in range(self.v_num):
                self.models[c].set(v, (word_cnt_array[c][v] + 1.0)/denominator)

    # 予測結果出力
    def predict(self, input_data):
        prob_array = self.__calc_log_prob(input_data)
        max_prob = prob_array.max()
        sum = 0.0
        for c in range(len(prob_array)):
            prob_array[c] -= max_prob
            prob_array[c] = math.exp(prob_array[c])
            sum += prob_array[c]

        return [ (prob/sum) *100.0 for prob in prob_array ]

    # 予測結果をもとに決定を行う(最大確率 or 確率で選択)
    def decide(self, input_data):
        prob_array = self.__calc_log_prob(input_data)
        max_prob_idx = prob_array.argmax()
        return max_prob_idx

    def __calc_log_prob(self, input_data):
        prob_array = np.array([ self.models[c].calc_log_prob(input_data) for c in range(self.cat_num) ])
        return prob_array


# テスト用関数
if __name__ == '__main__':
    pass
