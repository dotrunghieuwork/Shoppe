from flask import Flask, request, jsonify
import mysql.connector

app = Flask(__name__)

# Kết nối database
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root",      # đổi nếu bạn có mật khẩu
    database="shopbtl"   # đổi tên DB
)

@app.get("/")
def home():
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM users")
    rows = cursor.fetchall()
    return jsonify(rows)




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
