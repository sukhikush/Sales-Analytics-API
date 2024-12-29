# Sales Analytics API

## Description

This project provides a FastAPI service that performs complex data analytics on a large dataset stored in PostgreSQL.\
The dataset consists of sales data from multiple regions, with millions of records in a table called `sales_data`.\
The API provides a summary of the top 5 regions by total sales, including the ability to filter by date range and product category.

## Prerequisites
Ensure you have the following installed:
- Docker
- Docker Compose

## Setup

Follow these steps to get the application up and running with Docker Compose:

1. **Clone the repository**:
```bash
git clone <your-repository-url> cd <your-repository-directory>
```

2. **Start the application with Docker Compose**:
Run the following command to start all services defined in the `docker-compose.yml` file:
```bash
docker-compose up -d
```
This will create and start the containers in the background.

3. **Access the application**:
Open your browser and go to the application URL (`http://localhost:8000`).
   

## Endpoints
#### `http://localhost:8000/` 
- **Method:** GET
- **Response:** Root endpoint that returns a welcome message.
#### `http://localhost:8000/top-regions/`
- **Method:** GET
- **Query Parameters:**
  - `start_date` (required): Start date in `YYYY-MM-DD` format.
  - `end_date` (required): End date in `YYYY-MM-DD` format.
  - `product_category` (optional): Filter by product category. e.g. Clothing
- **Response:**
  ```json
  [
      {
          "region": "North",
          "total_sales": 2150.50
      },
      {
          "region": "West",
          "total_sales": 1300.00
      }
  ]

## Performance Optimization

The `sales_data` table has been optimized with the following 

- ### Partitioning:
  - Partition the table by `sale_date` to manage large datasets and speed up queries.
  - Partition has been created on `sale_date` storing yearly data in partition
  
- ### Indexes:
  
  - Index on the `sale_date` column for each partitions.
  - Composite index on `sale_date`, `category` for each partitions.

These indexes significantly improve the performance of queries, especially for filtering and grouping operations on large datasets.

## ⚠️ Note
We can **automate the partition creation** process.\
To automatically create partitions for upcoming years, we can:
- Schedule a job using PostgreSQL's pg_cron extension or an external cron job.
- Cloud Functions - Write a small script (e.g., in Python) to call the stored procedure at the start of each year.


## API Documentation

The API comes with built-in Swagger documentation, which provides a detailed and interactive interface for exploring and testing the API endpoints.

You can access the Swagger UI at:

\`\`\`
http://localhost:8000/docs
\`\`\`

This interface allows you to:

1. See all available endpoints
2. Read detailed descriptions of each endpoint
3. Try out the API directly from your browser
4. View request and response schemas

For a more readable, static documentation, you can also visit:

\`\`\`
http://localhost:8000/redoc
\`\`\`

These documentation pages are automatically generated and always up-to-date with the latest API changes.

