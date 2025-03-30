WITH CarStats AS (
    -- Получаем статистику для каждого автомобиля
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
),
ClassStats AS (
    -- Получаем среднюю позицию и количество автомобилей для каждого класса
    SELECT
        car_class,
        AVG(average_position) AS class_avg_position,
        COUNT(*) AS car_count
    FROM
        CarStats
    GROUP BY
        car_class
)
-- Выбираем автомобили с показателями выше среднего в своем классе
SELECT
    cs.car_name,
    cs.car_class,
    ROUND(cs.average_position, 4) AS average_position,
    cs.race_count,
    cs.car_country
FROM
    CarStats cs
JOIN
    ClassStats cls ON cs.car_class = cls.car_class
WHERE
    cs.average_position < cls.class_avg_position  -- лучше средней в классе
    AND cls.car_count >= 2  -- в классе должно быть минимум 2 автомобиля
ORDER BY
    cs.car_class,  -- сортировка по классу
    cs.average_position;  -- затем по средней позиции
