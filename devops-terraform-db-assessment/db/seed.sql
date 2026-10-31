INSERT INTO hotel_bookings (
    org_id,
    hotel_id,
    city,
    checkin_date,
    checkout_date,
    amount,
    status,
    created_at
)
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM numbers
    WHERE n < 200
)
SELECT
    CASE
        WHEN MOD(n, 3) = 0 THEN '11111111-1111-1111-1111-111111111111'
        WHEN MOD(n, 3) = 1 THEN '22222222-2222-2222-2222-222222222222'
        ELSE '33333333-3333-3333-3333-333333333333'
    END,
    CONCAT('HOTEL-', LPAD(n, 3, '0')),
    CASE
        WHEN MOD(n, 4) = 0 THEN 'Delhi'
        WHEN MOD(n, 4) = 1 THEN 'Hyderabad'
        WHEN MOD(n, 4) = 2 THEN 'Mumbai'
        ELSE 'Bangalore'
    END,
    CURRENT_DATE + INTERVAL MOD(n, 60) DAY,
    CURRENT_DATE + INTERVAL (MOD(n, 60) + 2) DAY,
    2000 + (n * 125.50),
    CASE
        WHEN MOD(n, 4) = 0 THEN 'confirmed'
        WHEN MOD(n, 4) = 1 THEN 'pending'
        WHEN MOD(n, 4) = 2 THEN 'cancelled'
        ELSE 'completed'
    END,
    CURRENT_TIMESTAMP - INTERVAL MOD(n, 30) DAY
FROM numbers;

INSERT INTO booking_events (
    booking_id,
    event_type,
    payload
)
SELECT
    id,
    CASE
        WHEN status = 'confirmed' THEN 'booking_confirmed'
        WHEN status = 'pending' THEN 'booking_pending'
        WHEN status = 'cancelled' THEN 'booking_cancelled'
        ELSE 'booking_completed'
    END,
    JSON_OBJECT(
        'source', 'assessment_seed',
        'city', city,
        'status', status
    )
FROM hotel_bookings
WHERE hotel_id LIKE 'HOTEL-%';
