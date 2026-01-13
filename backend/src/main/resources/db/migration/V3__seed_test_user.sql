-- Seed Test User for MVP
INSERT INTO users (id, email, is_verified) 
VALUES ('3fa85f64-5717-4562-b3fc-2c963f66afa6', 'test@example.com', true)
ON CONFLICT (id) DO NOTHING;
