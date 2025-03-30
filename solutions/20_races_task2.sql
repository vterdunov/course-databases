-- Находим автомобиль с наименьшей средней позицией в гонках
WITH CarAverages AS (
    -- Собираем статистику по каждому автомобилю
    SELECT
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position) AS average_position,  -- средняя позиция в гонках
        COUNT(r.race) AS race_count,          -- количество гонок
        cl.country AS car_country             -- страна производства
    FROM
        Cars c
    JOIN
        Results r ON c.name = r.car           -- связываем с результатами гонок
    JOIN
        Classes cl ON c.class = cl.class      -- берем информацию о классе
    GROUP BY
        c.name, c.class, cl.country
)
SELECT
    car_name,
    car_class,
    ROUND(average_position, 4) AS average_position,
    race_count,
    car_country
FROM
    CarAverages
WHERE
    -- Фильтруем только автомобили с минимальной позицией
    average_position = (SELECT MIN(average_position) FROM CarAverages)
ORDER BY
    car_name
LIMIT 1;
