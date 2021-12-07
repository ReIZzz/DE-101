# Подсчет позитивных и негативных высказываний в отзывах по каждому жилью, а также подсчет их разницы (rating)

import csv
import pandas as pd
from itertools import islice


with open('archive/listings_summary.csv', newline='') as l_s, \
        open('archive/reviews_summary.csv', newline='') as r_s, \
        open('archive/reviews.csv', newline='') as r, \
        open('Negative Adjectives (800)') as n_a_l, \
        open('Positive Adjectives (600)') as p_a_l:
    listings_sum = csv.reader(l_s)
    reviews_sum = csv.reader(r_s)
    reviews = csv.reader(r)
    reviews_obj = csv.DictReader(r)
    neg_adj_lst = n_a_l.readlines()
    pos_adj_lst = p_a_l.readlines()

    # # кол-во отзывов и жилья в файлах
    # row_lst_sum = sum(1 for row in listings_sum)
    # row_rev_sum = sum(1 for row2 in reviews_sum)
    #
    # print(f'Кол-во жилья {row_lst_sum}')  # 85069
    # print(f'Кол-во отзывов {row_rev_sum}')  # 1486237
    # print(f'Среднее кол-во отзывов на 1 жильё {row_rev_sum / row_lst_sum}')  # 17.47

    result_count_obj = []

    # for row in islice(reviews_obj, 100):
    for row in reviews_obj:
        pos_count = 0
        neg_count = 0

        # посчитаем кол-во позитивных прилагательных в отзыве
        for row_pos in pos_adj_lst:
            cnt = row['comments'].lower().count(row_pos.rstrip())
            pos_count = pos_count + cnt

        # посчитаем кол-во негатвных прилагательных в отзыве
        for row_neg in neg_adj_lst:
            cnt_2 = row['comments'].lower().count(row_neg.rstrip())
            neg_count = neg_count + cnt_2

        # добавим посчитанное в список результирующих значений
        result_count_obj.append({'listing_id': row['listing_id'],
                                 'positive': pos_count,
                                 'negative': neg_count,
                                 'rating': pos_count - neg_count})

# сложим значения по всем отзывам одного жилья (listing_id)
df = pd.DataFrame(result_count_obj)
df = df.groupby('listing_id')['positive', 'negative', 'rating'].sum()
df.to_csv('rating.csv')
