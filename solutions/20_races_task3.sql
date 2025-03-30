-- Находим классы с наименьшей средней позицией и информацию по каждому автомобилю из этих классов
WITH ClassAverages AS (
    -- Вычисляем среднюю позицию для каждого класса
    SELECT
        c.class,
        AVG(r.position) AS class_avg_position
    FROM
        Cars c
    JOIN
        Results r ON c.name = r.car
    GROUP BY
        c.class
),
BestClasses AS (
    -- Выбираем классы с минимальной средней позицией
    SELECT
        class
    FROM
        ClassAverages
    WHERE
        class_avg_position = (SELECT MIN(class_avg_position) FROM ClassAverages)
),
TotalRacesByClass AS (
    -- Считаем общее количество гонок для каждого класса
    SELECT
        c.class,
        COUNT(DISTINCT r.race) AS total_races
    FROM
        Cars c
    JOIN
        Results r ON c.name = r.car
    GROUP BY
        c.class
),
CarDetails AS (
    -- Собираем детальную информацию по каждому автомобилю
    SELECT
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count,
        cl.country AS car_country
    FROM
        Cars c
    JOIN
        Results r ON c.name = r.car
    JOIN
        Classes cl ON c.class = cl.class
    GROUP BY
        c.name, c.class, cl.country
)
-- Финальный результат
SELECT
    cd.car_name,
    cd.car_class,
    ROUND(cd.average_position, 4) AS average_position,
    cd.race_count,
    cd.car_country,
    trc.total_races
FROM
    CarDetails cd
JOIN
    BestClasses bc ON cd.car_class = bc.class
JOIN
    TotalRacesByClass trc ON cd.car_class = trc.class
ORDER BY
    cd.car_class, cd.car_name;
