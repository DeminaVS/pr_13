--1. Создать таблицу tablel со следующими параметрами: Поля: id1 int, id2 int, gen1 text, gen2 text. Сделать поля id1, id2, gen1 первичным ключом.
CREATE TABLE table1 (
    id1 int,
    id2 int,
    gen1 text,
    gen2 text,
    PRIMARY KEY (id1, id2, gen1)
);
--2. Создать таблицу table2 со следующими параметрами: возьмите набор полей table1 с помощью директивы LIKE.
CREATE TABLE table2 (LIKE table1);
--3. Проверить, сколько внешних таблиц присутствует в БД
SELECT COUNT(*) 
FROM pg_catalog.pg_foreign_table;
--4. Сгенерируйте данные и вставьте их в обе таблицы (200 тысяч и 400 тысяч значений соответственно)
-- Вставка 200.000 строк в table1
INSERT INTO table1 
SELECT gen, gen, gen::text || 'text1', gen::text || 'text2' 
FROM generate_series(1, 200000) gen;
-- Вставка 400.000 строк в table2
INSERT INTO table2 
SELECT gen, gen, gen::text || 'text1', gen::text || 'text2' 
FROM generate_series(1, 400000) gen;
--5. Посмотреть план соединения таблиц по id1
explain select * 
from table1
join table2 on table1.id1 = table2.id1;
--6. Используя таблицы table1 и table2, реализовать план запроса: План запроса встроенного инструмента pgAdmin, с помощью директивы EXPLAIN
SELECT t1.*,t2.*
FROM table1 t1
JOIN table2 t2 ON t1.id1 = t2.id1;
EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
select t1.* , t2.*
from table1 t1
join table2 t2 on t1.id1 = t2.id2;
--7. Реализовать запросы с использованием объединений, группировки, вложенного подзапроса. Экспортировать план в файл
--Запрос с объединением
-- Выбор записей, где id1 и id2 совпадают в обеих таблицах
EXPLAIN (ANALYZE, FORMAT JSON)
SELECT t1.id1, t1.id2, t1.gen1, t2.gen2
FROM table1 t1
INNER JOIN table2 t2 ON t1.id1 = t2.id1 AND t1.id2 = t2.id2;
--Запрос с группировкой
-- Подсчет количества записей для каждого gen1 в table1
EXPLAIN (ANALYZE, FORMAT JSON)
SELECT gen1, COUNT(*) as count
FROM table1
GROUP BY gen1
ORDER BY count DESC;
--Запрос с вложенным подзапросом
--Выбор записей из table1, где gen1 есть в table2
EXPLAIN (ANALYZE, FORMAT JSON)
SELECT id1, id2, gen1
FROM table1
WHERE gen1 IN (SELECT gen1 FROM table2);
