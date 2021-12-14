# Модуль 4: Интеграция и трансформация данных - ETL и ELT


## 1. Созданы 2 JOBs, 3 Transformations и настроено расписание обновления для тестовых данных в Pentaho Data Integration (PDI)

**Основной JOB**
![Основной JOB](https://github.com/ReIZzz/DE-101/blob/main/Module_4/4.4_introduction_pentaho/JOBs_add_Transformation/img/final_job.png)


**JOB для загрузки данных**
*(Данные загружены двумя разными способами):*
- Через шаг Pentaho – "HTTP"
- Через shell скрипт
```bash
  #!/bin/Bash
  curl "https://raw.githubusercontent.com/Data-Learn/data-engineering/master/DE-101%20Modules/Module01/DE%20-%20101%20Lab%201.1/Sample%20-%20Superstore.xls" --output /Users/ZN/Documents/GitHub/DE-101/Module_4/4.4_introduction_pentaho/Data/sample-superstore-shell.csv
  ```
![JOB для загрузки данных](https://github.com/ReIZzz/DE-101/blob/main/Module_4/4.4_introduction_pentaho/JOBs_add_Transformation/img/job_download_samplestore.png)


**Основная Transformation**
В рамках трансформации произведено объединение данных с разных листов загруженной книги excel

![Основная Transformation](https://github.com/ReIZzz/DE-101/blob/main/Module_4/4.4_introduction_pentaho/JOBs_add_Transformation/img/transformation_general.png)

**Transformation для отработки пребразования в различные типы выходных файлов**
В рамках трансформации произведена выборка необходимых данных и каждые из них сохранены в табличном или не табличном типе данных. Выбраны данные по продуктам, информации о возврате товара, а также выделены регионы и часть штатов доставки.

![Transformation фильтарция и вывод в файл](https://github.com/ReIZzz/DE-101/blob/main/Module_4/4.4_introduction_pentaho/JOBs_add_Transformation/img/transformation_for_task.png)

**Сформировано расписание для автоматизации запуска JOB**
При помощи shell скрипта реализован запуск финального JOBа через модуль Kitchen (PDI)

```bash
#!/bin/Bash
"/Applications/data-integration/kitchen.sh" /file:"/Users/ZN/Documents/GitHub/DE-101/Module_4/4.4_introduction_pentaho/JOBs_add_Transformation/final_job.kjb" /level:Basic
```
При помощи утилиты ```cronetab``` выполнение скрипта поставлено на расписание


## 2. Созданы 2 JOBs, 3 Transformations и настроено расписание обновления для тестовых данных в Pentaho Data Integration (PDI)
