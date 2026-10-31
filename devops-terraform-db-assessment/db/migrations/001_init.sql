CREATE TABLE IF NOT EXISTS hotel_bookings (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    org_id CHAR(36) NOT NULL,
    hotel_id VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    checkin_date DATE NOT NULL,
    checkout_date DATE NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    status VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT valid_booking_dates
        CHECK (checkout_date > checkin_date),

    CONSTRAINT valid_booking_amount
        CHECK (amount >= 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS booking_events (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    booking_id CHAR(36) NOT NULL,
    event_type VARCHAR(100) NOT NULL,
    payload JSON NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_booking_events_booking
        FOREIGN KEY (booking_id)
        REFERENCES hotel_bookings(id)
) ENGINE=InnoDB;
