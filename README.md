# pr_13
# Практическая работа 13
# Цель
Научиться анализировать план выполнения, сранивать разные типы запросов
# Выполнение заданий
# 13.1 Создать таблицу tablel со следующими параметрами: Поля: id1 int, id2 int, gen1 text, gen2 text. Сделать поля id1, id2, gen1 первичным ключом.
```
CREATE TABLE table1 (
    id1 int,
    id2 int,
    gen1 text,
    gen2 text,
    PRIMARY KEY (id1, id2, gen1)
);
```
![image](https://github.com/user-attachments/assets/2e651966-9c63-4f85-8715-536523730ac0)

# 13.2 Создать таблицу table2 со следующими параметрами: возьмите набор полей table1 с помощью директивы LIKE.
```
CREATE TABLE table2 (LIKE table1);
```
![image](https://github.com/user-attachments/assets/4562817a-c17a-4fdd-a7a0-5401f3471b83)

# 13.3 Проверить, сколько внешних таблиц присутствует в БД
```
SELECT COUNT(*) 
FROM pg_catalog.pg_foreign_table;
```
![image](https://github.com/user-attachments/assets/f8675334-7377-4324-b6bf-1590a00c44cf)

# 13.4 Сгенерировать данные и вставьте их в обе таблицы (200 тысяч и 400 тысяч значений соответственно)
Вставка 200.000 строк в table1
```
INSERT INTO table1 
SELECT gen, gen, gen::text || 'text1', gen::text || 'text2' 
FROM generate_series(1, 200000) gen;
```
![image](https://github.com/user-attachments/assets/214d097d-05c7-4f82-82a1-da3f9d06a328)

Вставка 400.000 строк в table2
```
INSERT INTO table2 
SELECT gen, gen, gen::text || 'text1', gen::text || 'text2' 
FROM generate_series(1, 400000) gen;
```
![image](https://github.com/user-attachments/assets/6afcb77d-123f-4d31-89d2-a788d5e89476)

# 13.5 Посмотреть план соединения таблиц по ключу id1
```
explain select *
from table1
join table2 on table1.id1 = table2.id1;
```
![image](https://github.com/user-attachments/assets/91ff4004-cf01-4ee5-a302-6f2dbc46249c)

# 13.6 Используя таблицы table1 и table2, реализуйте план запроса: План запроса встроенного инструмента pgAdmin, с помощью директивы EXPLAIN
```
SELECT t1.*,t2.*
FROM table1 t1
JOIN table2 t2 ON t1.id1 = t2.id1;

EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
select t1.* , t2.*
from table1 t1
join table2 t2 on t1.id1 = t2.id2;
```
![image](https://github.com/user-attachments/assets/9114f00e-0b59-455c-ab6b-7f361647f38b)

# 13.7 Реализовать запросы с использованием объединений, группировки, вложенного подзапроса. Экспортировать план в файл
Запрос с объединением

Выбор записей, где id1 и id2 совпадают в обеих таблицах
```
EXPLAIN (ANALYZE, FORMAT JSON)
SELECT t1.id1, t1.id2, t1.gen1, t2.gen2
FROM table1 t1
INNER JOIN table2 t2 ON t1.id1 = t2.id1 AND t1.id2 = t2.id2;
```
![image](https://github.com/user-attachments/assets/a6ab68de-dd6d-4865-b277-b5892ec07dce)
![image](https://github.com/user-attachments/assets/09af4da4-a749-4083-8530-d0dce585b2b5)

Запрос с группировкой

Подсчет количества записей для каждого gen1 в table1
```
EXPLAIN (ANALYZE, FORMAT JSON)
SELECT gen1, COUNT(*) as count
FROM table1
GROUP BY gen1
ORDER BY count DESC;
```
![image](https://github.com/user-attachments/assets/804c6fc6-4e15-426e-bb64-e3448499410b)
![image](https://github.com/user-attachments/assets/3f6063a6-7ee9-4a65-bfe5-eeab77527e33)

Запрос с вложенным подзапросом

Выбор записей из table1, где gen1 есть в table2
```
EXPLAIN (ANALYZE, FORMAT JSON)
SELECT id1, id2, gen1
FROM table1
WHERE gen1 IN (SELECT gen1 FROM table2);
```
![image](https://github.com/user-attachments/assets/a8ddcb9f-8e78-4911-9eb0-fba54ddb2ef1)
![image](https://github.com/user-attachments/assets/19c202b1-863c-44d9-952f-352679cc14c6)
# 13.8 Сравнить полученные результаты в пункте 13.6 локально с результатом на сайте
# Вывод
Научились анализировать планы выполнения, сравнили разные типы запросов




