import React, { useEffect, useState } from 'react';
import { Table, Button, Input, Modal, Form, InputNumber, Select, message, Popconfirm, Space, Tag } from 'antd';
import { PlusOutlined, EditOutlined, DeleteOutlined, SearchOutlined } from '@ant-design/icons';
import axiosClient from '../api/axiosClient';

const ProductPage = () => {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(false);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingProduct, setEditingProduct] = useState(null); // Lưu sp đang sửa
  const [form] = Form.useForm(); // Hook để quản lý Form

  // 1. Lấy danh sách sản phẩm (có hỗ trợ tìm kiếm)
  const fetchProducts = async (keyword = '') => {
    setLoading(true);
    try {
      // Gọi API (Backend cần viết file products.php nhận tham số search)
      const url = keyword ? `/products.php?search=${keyword}` : '/products.php';
      const response = await axiosClient.get(url);
      
      if (response.success) {
        setProducts(response.data);
      }
    } catch (error) {
      message.error('Lỗi tải danh sách sản phẩm');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchProducts();
  }, []);

  // 2. Xử lý khi bấm nút "Thêm mới"
  const handleAddNew = () => {
    setEditingProduct(null); // Reset về chế độ thêm
    form.resetFields();      // Xóa trắng form
    setIsModalOpen(true);    // Mở modal
  };

  // 3. Xử lý khi bấm nút "Sửa"
  const handleEdit = (record) => {
    setEditingProduct(record); // Lưu sp đang sửa
    form.setFieldsValue(record); // Điền dữ liệu cũ vào form
    setIsModalOpen(true);
  };

  // 4. Xử lý khi bấm nút "Xóa"
  const handleDelete = async (id) => {
    try {
      const response = await axiosClient.post('/delete_product.php', { id });
      if (response.success) {
        message.success('Xóa sản phẩm thành công');
        fetchProducts(); // Load lại bảng
      } else {
        message.error('Không thể xóa sản phẩm này');
      }
    } catch (error) {
      message.error('Lỗi hệ thống khi xóa');
    }
  };

  // 5. Xử lý khi bấm "Lưu" trong Modal (Cho cả Thêm và Sửa)
  const handleSave = async (values) => {
    try {
      let url = '/add_product.php';
      let msg = 'Thêm mới thành công';

      // Nếu đang sửa thì đổi API
      if (editingProduct) {
        url = '/update_product.php';
        values.id = editingProduct.product_id; // Gán thêm ID để biết sửa ai
        msg = 'Cập nhật thành công';
      }

      // Gọi API lưu dữ liệu
      const response = await axiosClient.post(url, values);

      if (response.success) {
        message.success(msg);
        setIsModalOpen(false); // Đóng modal
        fetchProducts();       // Load lại bảng
      } else {
        message.error('Có lỗi xảy ra: ' + response.message);
      }
    } catch (error) {
      message.error('Lỗi kết nối server');
    }
  };

  // Cấu hình cột cho bảng
  const columns = [
    {
      title: 'ID',
      dataIndex: 'product_id',
      width: 60,
    },
    {
      title: 'Tên Sản Phẩm',
      dataIndex: 'product_name',
      key: 'product_name',
      render: (text) => <b>{text}</b>,
    },
    {
      title: 'Giá tiền',
      dataIndex: 'price',
      key: 'price',
      render: (price) => `${parseFloat(price).toLocaleString()} đ`,
      sorter: (a, b) => a.price - b.price,
    },
    {
      title: 'Tồn kho',
      dataIndex: 'quantity',
      key: 'quantity',
      align: 'center',
      render: (qty) => (
        <Tag color={qty > 0 ? 'green' : 'red'}>
          {qty > 0 ? qty : 'Hết hàng'}
        </Tag>
      ),
    },
    {
      title: 'Trạng thái',
      dataIndex: 'status',
      render: (status) => (
        <Tag color={status === 'active' ? 'blue' : 'default'}>{status}</Tag>
      )
    },
    {
      title: 'Hành động',
      key: 'action',
      align: 'center',
      render: (_, record) => (
        <Space size="middle">
          <Button 
            type="primary" 
            ghost 
            icon={<EditOutlined />} 
            onClick={() => handleEdit(record)}
          />
          
          <Popconfirm
            title="Xóa sản phẩm?"
            description="Bạn có chắc chắn muốn xóa không?"
            onConfirm={() => handleDelete(record.product_id)}
            okText="Xóa"
            cancelText="Hủy"
          >
            <Button danger icon={<DeleteOutlined />} />
          </Popconfirm>
        </Space>
      ),
    },
  ];

  return (
    <div style={{ padding: 20 }}>
      {/* Header: Tiêu đề + Tìm kiếm + Nút Thêm */}
      <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 20 }}>
        <h1>Quản Lý Sản Phẩm</h1>
        <Space>
          <Input.Search
            placeholder="Tìm theo tên SP..."
            allowClear
            onSearch={(value) => fetchProducts(value)}
            style={{ width: 300 }}
          />
          <Button type="primary" icon={<PlusOutlined />} onClick={handleAddNew}>
            Thêm Sản Phẩm
          </Button>
        </Space>
      </div>

      {/* Bảng Dữ Liệu */}
      <Table 
        columns={columns} 
        dataSource={products} 
        rowKey="product_id"
        loading={loading}
        bordered
      />

      {/* Modal (Form Thêm/Sửa) */}
      <Modal
        title={editingProduct ? "Cập Nhật Sản Phẩm" : "Thêm Sản Phẩm Mới"}
        open={isModalOpen}
        onCancel={() => setIsModalOpen(false)}
        footer={null} // Ẩn nút mặc định để dùng nút của Form
      >
        <Form
          form={form}
          layout="vertical"
          onFinish={handleSave}
          initialValues={{ status: 'active', quantity: 10 }}
        >
          <Form.Item
            name="product_name"
            label="Tên sản phẩm"
            rules={[{ required: true, message: 'Vui lòng nhập tên!' }]}
          >
            <Input placeholder="VD: Áo thun..." />
          </Form.Item>

          <Form.Item
            name="description"
            label="Mô tả"
          >
            <Input.TextArea rows={2} />
          </Form.Item>

          <Row gutter={16}>
            <Col span={12}>
              <Form.Item
                name="price"
                label="Giá tiền"
                rules={[{ required: true, message: 'Nhập giá!' }]}
              >
                <InputNumber 
                  style={{ width: '100%' }} 
                  min={0} 
                  formatter={value => `${value}`.replace(/\B(?=(\d{3})+(?!\d))/g, ',')}
                  parser={value => value.replace(/\$\s?|(,*)/g, '')}
                />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item
                name="quantity"
                label="Số lượng"
                rules={[{ required: true }]}
              >
                <InputNumber style={{ width: '100%' }} min={0} />
              </Form.Item>
            </Col>
          </Row>

          <Form.Item name="seller_id" label="ID Người Bán (Tạm thời)" rules={[{ required: true }]}>
             <InputNumber style={{ width: '100%' }} />
          </Form.Item>

          <Form.Item name="status" label="Trạng thái">
            <Select>
              <Select.Option value="active">Đang bán (Active)</Select.Option>
              <Select.Option value="inactive">Ẩn (Inactive)</Select.Option>
            </Select>
          </Form.Item>

          <div style={{ textAlign: 'right' }}>
            <Button onClick={() => setIsModalOpen(false)} style={{ marginRight: 8 }}>
              Hủy
            </Button>
            <Button type="primary" htmlType="submit">
              {editingProduct ? "Lưu Cập Nhật" : "Tạo Mới"}
            </Button>
          </div>
        </Form>
      </Modal>
    </div>
  );
};

// Cần import Row và Col từ antd để chia cột trong form đẹp hơn
import { Row, Col } from 'antd';

export default ProductPage;