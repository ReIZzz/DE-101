# Модуль 4: Интеграция и трансформация данных - ETL и ELT


## 1. Создание 2 JOB и 3 трансформаций в Pentaho Data Integration (PDI), а также настройка расписания обновления через утилиту crone

### Основной JOB
В рамках данного JOBа проихводится загрузка данных с репозитория git двумя разными способами, объединение данных и вывод в несколько файлов разного типа
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
