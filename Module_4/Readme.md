# Модуль 4: Интеграция и трансформация данных - ETL и ELT


## Скачена и произведена настройка Pentaho Data Integration Community Edition
## Созданы 2 JOBs, 3 Transformations и настроено расписание обновления для тестовых данных
![Основной JOB]()

**JOB для загрузки данных**

Данные загружены двумя разными способами:
1. Через шаг Pentaho DI "HTTP"
2. Через Shell скрипт
<details>
  <summary>Shell script</summary>
  
  ```bash
  #!/bin/Bash
  curl "https://raw.githubusercontent.com/Data-Learn/data-engineering/master/DE-101%20Modules/Module01/DE%20-%20101%20Lab%201.1/Sample%20-%20Superstore.xls" --output /Users/**/Documents/GitHub/DE-101/Module_4/4.4_introduction_pentaho/Data/sample-superstore-shell.csv
  ```
</details>



- [x] [2.3. table_orders.sql](https://github.com/ReIZzz/DE-101/blob/main/Module%202/Create_table_orders.sql)
- [x] [2.3. table_people.sql](https://github.com/ReIZzz/DE-101/blob/main/Module%202/Create_table_people.sql)
- [x] [2.3. table_returns.sql](https://github.com/ReIZzz/DE-101/blob/main/Module%202/Create_table_returns.sql)

**SQL запросы на выборку данных из БД**

- [x] [2.3. query.sql](https://github.com/ReIZzz/DE-101/blob/main/Module%202/Reports.sql)

## Создание модели данных в SQLdbm для формирования новой схемы хранения данных

**Концептуальная модель**

![Концептуальная модель](https://github.com/ReIZzz/DE-101/blob/main/Module%202/2.4%20models%20of%20data/1.%20Conceptual%20model.png)

**Логическая модель**
