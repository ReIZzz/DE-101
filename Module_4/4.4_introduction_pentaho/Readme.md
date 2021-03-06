# Pentaho Data Integration
В этом разделе продемонстрирована работа с ETL инструментом `Pentaho` на примере данных [Sample - Super Store](https://github.com/Data-Learn/data-engineering/blob/master/DE-101%20Modules/Module01/DE%20-%20101%20Lab%201.1/Sample%20-%20Superstore.xls)
- Произведена загрузка данных из репозитория git
- Выполнена обработка полученных данных
- Выполнена загрузка в локально развернутую базу на `Postgres` 
- Настроено обновление по расписанию через утилиту `crone`

**Для этого созданы JOB и трансформации по загрузке, преобразованию, сохранению, верефикации и внесению в БД**


## 1. Создание 2 JOB и 3 трансформаций в Pentaho с настройкой расписания обновления через утилиту crone

### Основной JOB
В рамках данного JOBа производится загрузка данных с репозитория git двумя разными способами, объединение данных и вывод в несколько файлов разного типа
![Основной JOB](https://github.com/ReIZzz/DE-101/blob/main/Module_4/4.4_introduction_pentaho/JOBs_add_Transformation/img/final_job.png)


### JOB для загрузки данных
*Данные загружены двумя разными способами:*
- Через шаг Pentaho – "HTTP"
- Через shell скрипт
```bash
  #!/bin/Bash
  curl "https://raw.githubusercontent.com/Data-Learn/data-engineering/master/DE-101%20Modules/Module01/DE%20-%20101%20Lab%201.1/Sample%20-%20Superstore.xls" --output /Users/ZN/Documents/GitHub/DE-101/Module_4/4.4_introduction_pentaho/Data/sample-superstore-shell.csv
  ```
<img src="https://github.com/ReIZzz/DE-101/blob/main/Module_4/4.4_introduction_pentaho/JOBs_add_Transformation/img/job_download_samplestore.png" width = "200">

### Основная трансформация
В рамках трансформации произведено объединение данных с всех листов загруженной на предыдущем шаге книги excel

![Основная Transformation](https://github.com/ReIZzz/DE-101/blob/main/Module_4/4.4_introduction_pentaho/JOBs_add_Transformation/img/transformation_general.png)

### Трансформация вывода в различные типы файлов с разбивкой по необходимому критерию
В рамках трансформации произведена выборка необходимых данных и каждые из них сохранены в табличном или не табличном типе данных. Выбраны данные по продуктам, информации о возврате товара, а также выделены регионы и часть штатов доставки.

![Transformation фильтарция и вывод в файл](https://github.com/ReIZzz/DE-101/blob/main/Module_4/4.4_introduction_pentaho/JOBs_add_Transformation/img/transformation_for_task.png)

### Сформировано расписание для автоматизации запуска JOBа
При помощи shell скрипта реализован запуск финального JOBа через модуль Kitchen (PDI)

```bash
#!/bin/Bash
"/Applications/data-integration/kitchen.sh" /file:"/Users/ZN/Documents/GitHub/DE-101/Module_4/4.4_introduction_pentaho/JOBs_add_Transformation/final_job.kjb" /level:Basic
```
При помощи утилиты ```cronetab``` выполнение скрипта поставлено на расписание


## 2. Сформирован JOB и 3 трансформации для загрузки данных в развернутую локально БД (postgres)
*Целью данной задачи является повторить действия, реализованные на SQL в [Module 2](https://github.com/ReIZzz/DE-101/tree/main/Module%202#создание-модели-данных-в-sqldbm-для-формирования-новой-схемы-хранения-данных "Создание модели DW и загрузка данных из Staging"), с применением Pentaho DI*
- Произведена загрузка данных в БД в область со схемой для первоначалной загрузки сырых данных ```Staging```
- Сформирована отдельная схема хранилища данных ```DW``` в БД и сформированы таблицы измерений ```Dimension tables``` в которые загружены данные из области ```Staging```
- Сформирована таблица ```Fact table``` в которую загружены данные фактических значенией

### Основной JOB
![Основной JOB](https://github.com/ReIZzz/DE-101/blob/main/Module_4/4.4_introduction_pentaho/Lab_4.4/img/Pentaho%20Job.png)

### Загрузка данных в область Staging
<img src="https://github.com/ReIZzz/DE-101/blob/main/Module_4/4.4_introduction_pentaho/Lab_4.4/img/staging%20tables.png"
     width = "400">

### Загрузка данных в таблицы Dimension
![Загрузка данных в таблицы Dimension](https://github.com/ReIZzz/DE-101/blob/main/Module_4/4.4_introduction_pentaho/Lab_4.4/img/dim_tables.png)

### Загрузка данных в таблицу Fact
![Загрузка данных в таблицу Fact](https://github.com/ReIZzz/DE-101/blob/main/Module_4/4.4_introduction_pentaho/Lab_4.4/img/fact_table_sales.png)
