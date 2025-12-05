# Shop BTL Backend API

This is a Flask-based backend API for an e-commerce application. It provides endpoints for managing products, searching, and generating reports.

## Prerequisites

- Python 3.7+
- MySQL Server
- pip (Python package manager)

## Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd BE
   ```

2. Install the required Python packages:
   ```bash
   pip install flask mysql-connector-python
   ```

3. Set up the MySQL database:
   - Create a new MySQL database named `shopbtl`
   - Make sure all the required stored procedures are created in the database

## Configuration

Update the database connection details in `app.py` if needed:
```python
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root",      # Change if you have a different password
    database="shopbtl"
)
```

## Running the Application

1. Start the Flask development server:
   ```bash
   python app.py
   ```

2. The server will start on `http://localhost:5000`

## API Endpoints

### 1. Product Management

#### Insert Product
- **URL**: `POST /product/insert`
- **Request Body**:
  ```json
  {
    "product_name": "Product Name",
    "description": "Product Description",
    "price": 99.99,
    "quantity": 10,
    "seller_id": 1
  }
  ```
- **Response**: Returns the inserted product details

#### Update Product
- **URL**: `POST /product/update`
- **Request Body**:
  ```json
  {
    "product_id": 1,
    "product_name": "Updated Product Name",
    "price": 109.99,
    "quantity": 15,
    "status": "active"
  }
  ```
- **Response**: Returns the updated product details

#### Delete Product
- **URL**: `DELETE /product/delete`
- **Request Body**:
  ```json
  {
    "product_id": 1
  }
  ```
- **Response**: Confirmation of deletion

### 2. Product Search

#### Search Products
- **URL**: `POST /product/search`
- **Request Body**:
  ```json
  {
    "keyword": "laptop",
    "min_price": 500,
    "max_price": 2000
  }
  ```
- **All parameters are optional**
- **Response**: List of matching products

### 3. Reports

#### Top Selling Products
- **URL**: `POST /product/report-top-selling`
- **Request Body**:
  ```json
  {
    "min_sold_quantity": 5,
    "month": 12,
    "year": 2023
  }
  ```
- **Response**: List of top-selling products with their quantities sold

## Frontend Integration

To connect your frontend application to this backend:

1. Base URL: `http://localhost:5000`
2. Make sure to include the `Content-Type: application/json` header in your requests
3. Handle responses appropriately (check for HTTP status codes)

## Example Frontend Code (JavaScript)

```javascript
// Example: Searching for products
async function searchProducts(keyword, minPrice, maxPrice) {
  const response = await fetch('http://localhost:5000/product/search', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      keyword: keyword,
      min_price: minPrice,
      max_price: maxPrice
    })
  });
  return await response.json();
}
```

## Error Handling

The API returns error responses in the following format:
```json
{
  "error": "Error message here"
}
```

## Database Requirements

The following stored procedures must exist in your MySQL database:
- `sp_product_insert`
- `sp_product_update`
- `sp_product_delete`
- `sp_search_product_advanced`
- `sp_report_top_selling_products`

## License

This project is licensed under the MIT License.
