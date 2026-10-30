-- Optimizes city and date filtering in the booking report.
CREATE INDEX IF NOT EXISTS idx_hotel_bookings_city_created_at
ON hotel_bookings (city, created_at)
INCLUDE (org_id, status, amount);

-- Optimizes booking event lookups.
CREATE INDEX IF NOT EXISTS idx_booking_events_booking_id
ON booking_events (booking_id);
