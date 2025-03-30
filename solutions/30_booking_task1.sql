-- Ищем клиентов, которые бронировали в разных отелях минимум 3 раза
SELECT
    c.name,
    c.email,
    c.phone,
    COUNT(b.ID_booking) AS total_bookings,  -- считаем общее кол-во бронирований
    STRING_AGG(DISTINCT h.name, ', ') AS hotel_list,  -- собираем названия отелей через запятую
    ROUND(AVG(b.check_out_date - b.check_in_date), 4) AS avg_stay_duration  -- средняя продолжительность пребывания
FROM
    Booking b
JOIN
    Customer c ON b.ID_customer = c.ID_customer
JOIN
    Room r ON b.ID_room = r.ID_room
JOIN
    Hotel h ON r.ID_hotel = h.ID_hotel
GROUP BY
    c.ID_customer
HAVING
    COUNT(DISTINCT h.ID_hotel) > 1  -- клиент должен был остановиться минимум в 2 разных отелях
    AND COUNT(b.ID_booking) >= 3  -- и иметь не меньше 3 бронирований
ORDER BY
    total_bookings DESC;
