CREATE TABLE IF NOT EXISTS system_status (
    id SERIAL PRIMARY KEY,
    environment VARCHAR(50) NOT NULL,
    deployed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO system_status (environment) VALUES ('Blue');
