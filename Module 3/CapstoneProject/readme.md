# Финальный проект Модуля 3

"Представьте, что вы занимаетесь профессиональной сдачей жилья — берете в долгосрочную аренду объекты, а потом сдаете их в краткосрочную субаренду через Airbnb."

На датасете с информацией о недвижимости сдаваемой через [Airbnb а Лондоне](https://www.kaggle.com/labdmitriy/airbnb) необходимо построить аналитический дашборд.

Дата сет состоит из набора таблиц:
- `listings.csv` — детальная информация про каждый объект
- `listings_summary.csv` — суммарная информация про каждый объект (меньше колонок)
- `calendar.csv` — календарь доступности объекта по дням за год
- `neighbourhoods.csv` — список районов
- `neighbourhoods.geojson` — гео-шейп района
- `reviews.csv` — список отзывов по каждому объекту
- `reviews_summary.csv` — суммарная информация по отзывам на объект

Имеющиеся данные обогащены сведениями об удовлетворенности гостей. Удовлетворенность рассчитана как отношение количества прилагательных имеющих положитлеьный эмоциональный окрас к количеству имеющих отрицательный эмоциональный окрас встречающихся в отзывах гостей. Для этого:

- Сформировано два списка прилагательных имеющих [положительный эмоциональный окрас (600 шт)](https://github.com/ReIZzz/DE-101/blob/main/Module%203/CapstoneProject/Positive%20Adjectives%20(600)) и [отрицательный эмоциональный окрас (800 шт)](https://github.com/ReIZzz/DE-101/blob/main/Module%203/CapstoneProject/Negative%20Adjectives%20(800))
- Написан [скрипт на `Python`](https://github.com/ReIZzz/DE-101/blob/main/Module%203/CapstoneProject/prepare.py) для подсчета процента удовлетворенности гостей
- [Результаты подсчета](https://github.com/ReIZzz/DE-101/blob/main/Module%203/CapstoneProject/rating.csv) добавлены к имеющемуся датасету для посторения дашборда

Дашборд на [TableauPublic](https://public.tableau.com/views/CapstoneProjectAirbnb_16358502709610/Dashboard?:language=en-US&:display_count=n&:origin=viz_share_link)


![Дашборд Airbnb](https://github.com/ReIZzz/DE-101/blob/main/Module%203/CapstoneProject/img/Listings%20Analysis%20Dash%20(Airbnb).png)
