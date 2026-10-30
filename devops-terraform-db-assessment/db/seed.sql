WITH inserted_bookings AS (
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
    SELECT
        CASE
            WHEN n % 3 = 0 THEN '11111111-1111-1111-1111-111111111111'::UUID
            WHEN n % 3 = 1 THEN '22222222-2222-2222-2222-222222222222'::UUID
            ELSE '33333333-3333-3333-3333-333333333333'::UUID
        END,
        'HOTEL-' || LPAD(n::TEXT, 3, '0'),
        CASE
            WHEN n % 4 = 0 THEN 'Delhi'
            WHEN n % 4 = 1 THEN 'Hyderabad'
            WHEN n % 4 = 2 THEN 'Mumbai'
            ELSE 'Bangalore'
        END,
        CURRENT_DATE + (n % 60),
        CURRENT_DATE + (n % 60) + 2,
        (2000 + (n * 125.50))::NUMERIC(12,2),
        CASE
            WHEN n % 4 = 0 THEN 'confirmed'
            WHEN n % 4 = 1 THEN 'pending'
            WHEN n % 4 = 2 THEN 'cancelled'
            ELSE 'completed'
        END,
        CURRENT_TIMESTAMP - (n % 30) * INTERVAL '1 day'
    FROM generate_series(1, 200) AS n
    RETURNING id, status, city
)
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
    jsonb_build_object(
        'source', 'assessment_seed',
        'city', city,
        'status', status
    )
FROM inserted_bookings;

