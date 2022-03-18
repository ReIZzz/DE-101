# Module 1

В этом модуле представлено описание архитектуры имеющегося аналитического решения компании X.

**3 слоя архитектуры:**
1. `Source Layer` - слой систем источников данных OLTP (Online Transactional Processing) - обработка транзакций;

2. `Storage Layer` - слой хранения данных для аналитики (DW, Data Lake, Data Platform);

3. `Business Layer` - слой доступа к данным для бизнес пользователей через инструменты BI, SQL и т.п. Происходит подключение к системам для просмотра отчётов. 

Иногда используется ещё один слой - `Processing/Compute Layer`, где происходит трансформация данных перед загрузкой в хранилище.

<details>
  <summary>Вариант архитектуры аналитическго решения компании X. Исходное и три варианта целевого состояния.</summary>
  
  ![Architecture](https://github.com/ReIZzz/DE-101/blob/main/Module%201/Architecture/Architecture.png)
  
</details>

