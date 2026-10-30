SELECT
    org_id,
    status,
    COUNT(*) AS total_bookings,
    SUM(amount) AS total_amount
FROM hotel_bookings
WHERE city = 'Delhi'
  AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY org_id, status
ORDER BY org_id, status;

