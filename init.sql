-- CREATE TABLE sales_data (
--     id SERIAL PRIMARY KEY,
--     region VARCHAR(50),
--     category VARCHAR(50),
--     sale_date DATE,
--     total_sales DECIMAL(10, 2)
-- );

-- Create the partitioned table
CREATE TABLE sales_data_partitioned (
    id SERIAL PRIMARY KEY,
    region VARCHAR(50),
    category VARCHAR(50),
    sale_date DATE NOT NULL,
    total_sales DECIMAL(10, 2)
) PARTITION BY RANGE (sale_date);




-- Create partitions for specific years
CREATE TABLE sales_data_2022 PARTITION OF sales_data_partitioned FOR VALUES FROM ('2022-01-01') TO ('2022-12-31');
CREATE TABLE sales_data_2023 PARTITION OF sales_data_partitioned FOR VALUES FROM ('2023-01-01') TO ('2023-12-31');
CREATE TABLE sales_data_2024 PARTITION OF sales_data_partitioned FOR VALUES FROM ('2024-01-01') TO ('2024-12-31');
CREATE TABLE sales_data_2025 PARTITION OF sales_data_partitioned FOR VALUES FROM ('2025-01-01') TO ('2025-12-31');

-- Default partition for data outside defined ranges
CREATE TABLE sales_data_default PARTITION OF sales_data_partitioned DEFAULT;




-- Index on sale_date and category for each partition
CREATE INDEX idx_sales_data_2022_sales_date ON sales_data_2022 (sale_date);
CREATE INDEX idx_sales_data_2022_sales_date_category ON sales_data_2022 (sale_date,Lower(category));

CREATE INDEX idx_sales_data_2023_sales_date ON sales_data_2023 (sale_date);
CREATE INDEX idx_sales_data_2023_sales_date_category ON sales_data_2023 (sale_date,Lower(category));

CREATE INDEX idx_sales_data_2024_sales_date ON sales_data_2024 (sale_date);
CREATE INDEX idx_sales_data_2024_sales_date_category ON sales_data_2024 (sale_date,Lower(category));

CREATE INDEX idx_sales_data_2025_sales_date ON sales_data_2025 (sale_date);
CREATE INDEX idx_sales_data_2025_sales_date_category ON sales_data_2025 (sale_date,Lower(category));




-- Insert dummy data
INSERT INTO sales_data (region, category, sale_date, total_sales)
VALUES
    ('North America', 'Electronics', '2023-01-01', 10000.00),
    ('Europe', 'Clothing', '2023-01-02', 8000.00),
    ('Asia', 'Home Goods', '2023-01-03', 12000.00),
    ('South America', 'Electronics', '2023-01-04', 9000.00),
    ('Africa', 'Clothing', '2023-01-05', 5000.00),
    ('Australia', 'Home Goods', '2023-01-06', 7000.00),
    ('North America', 'Clothing', '2023-01-07', 11000.00),
    ('Europe', 'Electronics', '2023-01-08', 13000.00),
    ('Asia', 'Clothing', '2023-01-09', 15000.00),
    ('South America', 'Home Goods', '2023-01-10', 6000.00);

-- Add more dummy data as needed to simulate millions of records

