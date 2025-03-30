WITH AveragePositions AS (
    -- Вычисляем среднюю позицию и количество гонок для каждого автомобиля
    SELECT
        c.name AS car_name,
        c.class AS car_class,
        ROUND(AVG(r.position)::numeric, 4) AS average_position,
        COUNT(r.race) AS race_count
    FROM
        Cars c
    JOIN
        Results r ON c.name = r.car
    GROUP BY
        c.name, c.class
),
RankedCars AS (
    -- Ранжируем автомобили в каждом классе по средней позиции
    SELECT
        car_name,
        car_class,
        average_position,
        race_count,
        RANK() OVER (PARTITION BY car_class ORDER BY average_position) AS rank
    FROM
        AveragePositions
)
-- Выбираем автомобили с рангом 1
SELECT
    car_name,
    car_class,
    average_position,
    race_count
FROM
    RankedCars
WHERE
    rank = 1
ORDER BY
    average_position;
