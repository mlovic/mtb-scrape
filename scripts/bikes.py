# Init script for analyzing foromtb.com bike data
#
# Loads all bike data from app database into pandas DataFame

import sqlite3
import pandas as pd
import matplotlib.pyplot as plt
con = sqlite3.connect('db/foromtb.db')

sql = ('select size, travel, is_sold, username, visits, models.name AS model, brands.name AS brand, price, frame_only, posts.last_message_at, posts.posted_at '
       'from bikes '
       'LEFT Join models ON bikes.model_id=models.id '
       'LEFT JOIN brands ON bikes.brand_id=brands.id '
       'LEFT JOIN posts ON bikes.post_id=posts.id')

bikes = pd.read_sql(sql, con)
