# Задание модуля 2

## Устанавка PostgreSQL на локальный компьютер и загрузка данных в БД

**Загрузка данных (SQL запросы)**

- [Create table orders.sql](https://github.com/ReIZzz/DE-101/blob/main/Module%202/Create_table_stg.orders.sql)
- [Create table people.sql](https://github.com/ReIZzz/DE-101/blob/main/Module%202/Create_table_stg.people.sql)
- [Create table returns.sql](https://github.com/ReIZzz/DE-101/blob/main/Module%202/Create_table_stg.returns.sql)

**SQL запросы на выборку данных из БД**

- [Reports query.sql](https://github.com/ReIZzz/DE-101/blob/main/Module%202/Reports.sql)

## Создание модели данных в SQLdbm для формирования новой схемы хранения данных

**Концептуальная модель**

![Концептуальная модель](https://github.com/ReIZzz/DE-101/blob/main/Module%202/2.4%20models%20of%20data/1.%20Conceptual%20model.png)

**Логическая модель**

![Логическая модель](https://github.com/ReIZzz/DE-101/blob/main/Module%202/2.4%20models%20of%20data/2.%20Logical%20model.png)

**Физическая модель**

![Физическая модель](https://github.com/ReIZzz/DE-101/blob/main/Module%202/2.4%20models%20of%20data/3.%20Physical%20model.png)

**Перенос данных в новую схему хранения данных**

- [SQL скрипт переноса данных в новую схему](https://github.com/ReIZzz/DE-101/blob/main/Module%202/Create_analytics_db_SuperStore.sql)

**Анализ и устранение коллизий в исходных данных. Проверка полноты перенесенных данных**

- [SQL скрипт проверки и корректировки данных](https://github.com/ReIZzz/DE-101/blob/main/Module%202/Create_analytics_db_SuperStore.sql)

## Создание БД в AWS RDS и загрузка данных в облако

- Создаем учетную запись в AWS
- Создаем БД PostgreSQL и настраиваем к ней доступ используя сервис AWS RDS 
- Создаем подключение к новой БД через SQL клиент (DBeaver) и загружаем данные из модуля 2.3 (Superstore dataset):
  - В staging (схема БД stg)
  - В Business Layer (схема БД dw)

## Создание дашборда Google Data Studio на данных из БД в AWS RDS

[Дашборд в Google Data Studio](https://datastudio.google.com/reporting/42abf109-a99d-4679-9261-7f3320facb7b)

![Дашборд](https://github.com/ReIZzz/DE-101/blob/main/Module%202/Super%20Store%20Dashboard%20(google%20datastudio).png)
