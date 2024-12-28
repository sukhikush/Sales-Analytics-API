from fastapi import FastAPI, HTTPException, Query
from sqlalchemy import create_engine, text
from datetime import date
import os
from pydantic import BaseModel
from typing import List, Optional

app = FastAPI(
    title="Sales Analytics API",
    description="API for analyzing sales data across multiple regions",
    version="1.0.0",
)

# Database connection
DATABASE_URL = os.getenv("DATABASE_URL")
engine = create_engine(DATABASE_URL)

class RegionSales(BaseModel):
    region: str
    total_sales: float

class TopRegionsResponse(BaseModel):
    top_regions: List[RegionSales]

@app.get("/")
async def root():
    """
    Root endpoint that returns a welcome message.
    """
    return {"message": "Welcome to the Sales Analytics API"}

@app.get("/top_regions", response_model=TopRegionsResponse)
async def get_top_regions(
    start_date: date = Query(..., description="Start date in YYYY-MM-DD format"),
    end_date: date = Query(..., description="End date in YYYY-MM-DD format"),
    category: Optional[str] = Query(None, description="Product category to filter by")
):
    """
    Get the top 5 regions by total sales within a specified date range and optional product category.

    - **start_date**: The start date in YYYY-MM-DD format (inclusive)
    - **end_date**: The end date in YYYY-MM-DD format (inclusive)
    - **category**: Optional product category to filter by

    Returns a list of the top 5 regions with their total sales.
    """
    
    try:
        query = text("""
            SELECT region, SUM(total_sales) as total_sales
            FROM sales_data
            WHERE sale_date BETWEEN :start_date AND :end_date
            AND (:category IS NULL OR Lower(category) = Lower(:category))
            GROUP BY region
            ORDER BY total_sales DESC
            LIMIT 5
        """)
        
        with engine.connect() as connection:
            result = connection.execute(query, {
                "start_date": start_date,
                "end_date": end_date,
                "category": category
            })
            top_regions = [{"region": row[0], "total_sales": float(row[1])} for row in result]
        
        return {"top_regions": top_regions}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

