# Модуль 1

В этом модуле:
- описана архитектура имеющегося аналитического решения компании X
- создан [интерактивный дашборд для аналитики в `Excel`](https://github.com/ReIZzz/DE-101/blob/main/Module%201/Superstore%20Dashboard/Superstore%20Dashboard.xlsx) на данных магазина [Sample - Superstore.xls](https://github.com/Data-Learn/data-engineering/blob/master/DE-101%20Modules/Module01/DE%20-%20101%20Lab%201.1/Sample%20-%20Superstore.xls)
- сохранены [отчеты из дашборда на дату в формате pdf](https://github.com/ReIZzz/DE-101/blob/main/Module%201/Superstore%20Dashboard/Состояние%20Superstore%20на%20дату.pdf)

##### [(полное описание задания модуля №1)](https://github.com/Data-Learn/data-engineering/blob/master/DE-101%20Modules/Module01/DE%20-%20101%20Lab%201.1/readme.md)

#### 3 слоя архитектуры:
1. `Source Layer` - слой систем источников данных OLTP (Online Transactional Processing) - обработка транзакций;

2. `Storage Layer` - слой хранения данных для аналитики (DW, Data Lake, Data Platform);

3. `Business Layer` - слой доступа к данным для бизнес пользователей через инструменты BI, SQL и т.п. Происходит подключение к системам для просмотра отчётов. 

Иногда используется ещё один слой - `Processing/Compute Layer`, где происходит трансформация данных перед загрузкой в хранилище.

________________
  
### Вариант архитектуры аналитическго решения компании X. Исходное и три варианта целевого состояния
![Architecture](https://github.com/ReIZzz/DE-101/blob/main/Module%201/Architecture/Architecture.png)
  
### [Превью дашборда в Excel](https://github.com/ReIZzz/DE-101/blob/main/Module%201/Superstore%20Dashboard/Superstore%20Dashboard.xlsx)
![Architecture](https://github.com/ReIZzz/DE-101/blob/main/Module%201/Superstore%20Dashboard/Превью%20дашборд%20в%20Excel.png)
