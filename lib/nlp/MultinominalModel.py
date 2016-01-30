# -*- coding: utf-8 -*-

#
# @file 	MultinominalModel.py
# @author 	Masakaze Sato
# @brief 	多項モデル
#

import math
import sys

import numpy as np

# 多項目モデル
class MultinominalModel:

    # コンストラクタ
    def __init__(self, dim):
        self.dim = dim
        self.prob = np.array([0.0]*dim)

    def get_dim(self):
        return self.dim

    def get(self, d):
        self.__check_dim(d)
        return self.prob[d]

    def set(self, d, value):
        self.__check_dim(d)
        self.prob[d] = value

    def init_param(self, alpha_array):
        self.prob = np.random.dirichlet(alpha_array)
        # 0になるとlogとれないので、最小値をいれておく @fixme 正規化
        for i in range(len(self.prob)):
            if self.prob[i] < sys.float_info.min:
                self.prob[i] = sys.float_info.min

    # 対数確率計算
    # @param data 多項モデルのインデックス配列 (ex. [0, 3, 2, dim-1, ...])
    def calc_log_prob(self, data):
        log_prob = 0.0
        for v in data:
            log_prob += math.log(self.prob[v])
        return log_prob
    

    def __check_dim(self, d):
#        assert( d >= 0 and d < self.dim )
        pass

# テスト用メイン関数
if __name__ == '__main__':
    dim = 10

    model = MultinominalModel(dim)
    assert( model.dim == dim )
    assert( model.prob.size == dim )
    model.set(0, 1)
    assert( model.get(0) == 1 )
    model.set(1, 0.5)
    assert( model.get(1)-0.5 < 0.00001 )
