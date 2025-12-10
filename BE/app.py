from flask import Flask, request, jsonify
from flask_cors import CORS
import mysql.connector

app = Flask(__name__)
CORS(app)  # Cho phép FE gọi API từ domain khác

# Kết nối database
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="24102005",      # đổi nếu bạn có mật khẩu
    database="shopbtl"   # đổi tên DB
)

@app.get("/")
def home():
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM users")
    rows = cursor.fetchall()
    return jsonify(rows)


# =====================================================
# API GET ALL PRODUCTS - Lấy danh sách tất cả sản phẩm
# =====================================================
@app.get("/products")
def get_all_products():
    try:
        cursor = db.cursor(dictionary=True)
        query = """
            SELECT p.product_id, p.product_name, p.description, p.price, 
                   p.quantity, p.status, p.created_date, p.seller_id,
                   u.username as seller_name
            FROM product p
            LEFT JOIN seller s ON p.seller_id = s.user_id
            LEFT JOIN users u ON s.user_id = u.id
            WHERE p.status != 'deleted'
            ORDER BY p.created_date DESC
        """
        cursor.execute(query)
        products = cursor.fetchall()
        return jsonify({"success": True, "data": products})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 400


# =====================================================
# API GET ALL ORDERS - Lấy danh sách tất cả đơn hàng
# =====================================================
@app.get("/orders")
def get_all_orders():
    try:
        cursor = db.cursor(dictionary=True)
        query = """
            SELECT o.order_id, o.order_date, o.total_cost, o.status,
                   o.customer_id, 
                   CONCAT(u.fname, ' ', u.lname) as customer_name,
                   od.product_id, p.product_name, od.quantity, od.unit_price
            FROM orders o
            LEFT JOIN users u ON o.customer_id = u.id
            LEFT JOIN order_detail od ON o.order_id = od.order_id
            LEFT JOIN product p ON od.product_id = p.product_id
            ORDER BY o.order_date DESC
        """
        cursor.execute(query)
        orders = cursor.fetchall()
        return jsonify({"success": True, "data": orders})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 400


# =====================================================
# API UPDATE ORDER STATUS - Cập nhật trạng thái đơn hàng
# =====================================================
@app.post("/orders/update-status")
def update_order_status():
    try:
        body = request.get_json()
        order_id = body.get("order_id")
        status = body.get("status")
        
        cursor = db.cursor(dictionary=True)
        query = "UPDATE orders SET status = %s WHERE order_id = %s"
        cursor.execute(query, (status, order_id))
        db.commit()
        
        return jsonify({"success": True, "message": "Cập nhật thành công"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 400


# 2.1

# =====================================================
# 1️⃣ INSERT PRODUCT
# =====================================================
@app.post("/product/insert")
def insert_product():
    body = request.get_json()

    try:
        cursor = db.cursor(dictionary=True)
        cursor.callproc("sp_product_insert", [
            body.get("product_name"),
            body.get("description"),
            body.get("price"),
            body.get("quantity"),
            body.get("seller_id")
        ])

        # Lấy SELECT trong procedure
        result = []
        for r in cursor.stored_results():
            result = r.fetchall()

        db.commit()
        return jsonify(result)

    except Exception as e:
        return {"error": str(e)}, 400



# =====================================================
# 2️⃣ UPDATE PRODUCT
# =====================================================
@app.post("/product/update")
def update_product():
    body = request.get_json()

    try:
        cursor = db.cursor(dictionary=True)
        cursor.callproc("sp_product_update", [
            body.get("product_id"),
            body.get("product_name"),
            body.get("price"),
            body.get("quantity"),
            body.get("status")
        ])

        result = []
        for r in cursor.stored_results():
            result = r.fetchall()

        db.commit()
        return jsonify(result)

    except Exception as e:
        return {"error": str(e)}, 400



# =====================================================
# 3️⃣ DELETE PRODUCT
# =====================================================
@app.delete("/product/delete")
def delete_product():
    body = request.get_json()

    try:
        cursor = db.cursor(dictionary=True)
        cursor.callproc("sp_product_delete", [
            body.get("product_id")
        ])

        result = []
        for r in cursor.stored_results():
            result = r.fetchall()

        db.commit()
        return jsonify(result)

    except Exception as e:
        return {"error": str(e)}, 400




# 2.3

# =================================================================
# 4️⃣ SEARCH PRODUCT (sp_search_product_advanced)
# =================================================================
@app.post("/product/search")
def search_product():
    body = request.get_json()

    keyword = body.get("keyword")
    min_price = body.get("min_price")
    max_price = body.get("max_price")

    try:
        cursor = db.cursor(dictionary=True)
        cursor.callproc("sp_search_product_advanced", [
            keyword,
            min_price,
            max_price
        ])

        # Lấy SELECT trong procedure
        result = []
        for r in cursor.stored_results():
            result = r.fetchall()

        return jsonify(result)

    except Exception as e:
        return {"error": str(e)}, 400



# =================================================================
# 5️⃣ REPORT TOP SELLING PRODUCTS (sp_report_top_selling_products)
# =================================================================
@app.post("/product/report-top-selling")
def report_top_selling():
    body = request.get_json()

    min_sold = body.get("min_sold_quantity")
    month = body.get("month")
    year = body.get("year")

    try:
        cursor = db.cursor(dictionary=True)
        cursor.callproc("sp_report_top_selling_products", [
    int(min_sold),
    int(month),
    int(year)
        ])

        result = []
        for r in cursor.stored_results():
            result = r.fetchall()

        return jsonify(result)

    except Exception as e:
        return {"error": str(e)}, 400








if __name__ == "__main__":
    app.run(debug=True, port=5000)
