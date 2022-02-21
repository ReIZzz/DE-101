# Модуль 4.5 34 ETL Подсистемы

## Extraction
###  1. Data Profiling System

Три уровня выполнения Data Profiling:
1. **Column Profile:** сбор статистических данных на уровне в одной столбцами;
    * Number of distinct values: How many unique entries does the column contain? 
    * Number of NULL and empty values: How many records have no value or an empty value? 
    * Highest and lowest values: Not only for numeric but also for textual data. 
    * Numeric sum, median, average, and standard deviation: Various calculations on the numeric values and value distribution. 
    * String patterns and length: Are the values correctly stored? (For example, German postal codes should contain five digits.) 
    * Number of words, number of upper and lowercase characters: What’s the total number of words in the column and are the words all upper, lower or mixed case? 
    * Frequency counts: What are the top and bottom N items in a column? 


1. **Dependency Profile:** проверка зависимости в таблице между разными столбцами;
    * Как пример, можно привести такие зависимости как: Принадлежность города Штату(Округу), принадлежность улице городу, соотношение с индексом.

1. **Join Profile:** проверка зависимости между разными таблицами.
    * Можно ли найти данные требуемые в одной таблице в другой. Каково соотношение всего количества одних данных и использование в других таблицах (как пример, количество клиентов всего и количество клиентов сделавших заказы)

###  2. Change Data Capture System (CDC)
