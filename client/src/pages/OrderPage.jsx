import { useEffect, useState } from 'react';
import { Table, Select, Card, Row, Col, message, Tag } from 'antd';
import { ShoppingCartOutlined, CheckCircleOutlined, ClockCircleOutlined, DollarOutlined } from '@ant-design/icons';
import axiosClient from '../api/axiosClient';

const OrderPage = () => {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(false);
  const [stats, setStats] = useState({
    total: 0,
    pending: 0,
    delivered: 0,
    totalRevenue: 0
  });

  // Lấy danh sách đơn hàng từ API
  const fetchOrders = async () => {
    setLoading(true);
    try {
      const response = await axiosClient.get('/orders');
      if (response.success) {
        setOrders(response.data);
        calculateStats(response.data);
      }
    } catch (error) {
      message.error('Không thể tải danh sách đơn hàng');
    } finally {
      setLoading(false);
    }
  };

  // Tính toán thống kê
  const calculateStats = (orderList) => {
    const total = orderList.length;
    const pending = orderList.filter(o => o.status === 'pending' || o.status === 'shipped').length;
    const delivered = orderList.filter(o => o.status === 'delivered').length;
    const totalRevenue = orderList
      .filter(o => o.status === 'delivered')
      .reduce((sum, o) => sum + parseFloat(o.total_cost || 0), 0);
    
    setStats({ total, pending, delivered, totalRevenue });
  };

  // Cập nhật status đơn hàng
  const handleStatusChange = async (orderId, newStatus) => {
    try {
      const response = await axiosClient.post('/orders/update-status', {
        order_id: orderId,
        status: newStatus
      });
      
      if (response.success) {
        message.success('Cập nhật trạng thái thành công');
        fetchOrders(); // Reload lại danh sách
      } else {
        message.error('Cập nhật thất bại');
      }
    } catch (error) {
      message.error('Lỗi khi cập nhật trạng thái');
    }
  };

  useEffect(() => {
    fetchOrders();
  }, []);

  // Cấu hình cột cho Table
  const columns = [
    {
      title: 'ID',
      dataIndex: 'order_id',
      key: 'order_id',
      width: 70,
    },
    {
      title: 'Khách hàng',
      dataIndex: 'customer_name',
      key: 'customer_name',
    },
    {
      title: 'Sản phẩm',
      dataIndex: 'product_name',
      key: 'product_name',
    },
    {
      title: 'Số lượng',
      dataIndex: 'quantity',
      key: 'quantity',
      width: 100,
      align: 'center',
    },
    {
      title: 'Tổng tiền',
      dataIndex: 'total_cost',
      key: 'total_cost',
      width: 120,
      render: (amount) => `${parseFloat(amount || 0).toLocaleString()} đ`,
    },
    {
      title: 'Ngày đặt',
      dataIndex: 'order_date',
      key: 'order_date',
      width: 150,
    },
    {
      title: 'Trạng thái',
      dataIndex: 'status',
      key: 'status',
      width: 150,
      render: (status, record) => (
        <Select
          value={status}
          style={{ width: 130 }}
          onChange={(value) => handleStatusChange(record.order_id, value)}
        >
          <Select.Option value="pending">Pending</Select.Option>
          <Select.Option value="shipped">Shipped</Select.Option>
          <Select.Option value="delivered">Delivered</Select.Option>
          <Select.Option value="cancelled">Cancelled</Select.Option>
        </Select>
      ),
    },
  ];

  return (
    <div>
      <h1 style={{ marginBottom: 24 }}>Trang Đơn Hàng (OrderPage)</h1>
      
      {/* Dashboard - Các Card thống kê */}
      <Row gutter={16} style={{ marginBottom: 24 }}>
        <Col span={6}>
          <Card>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <div>
                <div style={{ color: '#888', fontSize: 14 }}>Tổng đơn hàng</div>
                <div style={{ fontSize: 24, fontWeight: 'bold' }}>{stats.total}</div>
              </div>
              <ShoppingCartOutlined style={{ fontSize: 40, color: '#1890ff' }} />
            </div>
          </Card>
        </Col>
        
        <Col span={6}>
          <Card>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <div>
                <div style={{ color: '#888', fontSize: 14 }}>Đang xử lý</div>
                <div style={{ fontSize: 24, fontWeight: 'bold' }}>{stats.pending}</div>
              </div>
              <ClockCircleOutlined style={{ fontSize: 40, color: '#faad14' }} />
            </div>
          </Card>
        </Col>
        
        <Col span={6}>
          <Card>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <div>
                <div style={{ color: '#888', fontSize: 14 }}>Đã giao</div>
                <div style={{ fontSize: 24, fontWeight: 'bold' }}>{stats.delivered}</div>
              </div>
              <CheckCircleOutlined style={{ fontSize: 40, color: '#52c41a' }} />
            </div>
          </Card>
        </Col>
        
        <Col span={6}>
          <Card>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <div>
                <div style={{ color: '#888', fontSize: 14 }}>Doanh thu</div>
                <div style={{ fontSize: 24, fontWeight: 'bold' }}>
                  {stats.totalRevenue.toLocaleString()} đ
                </div>
              </div>
              <DollarOutlined style={{ fontSize: 40, color: '#eb2f96' }} />
            </div>
          </Card>
        </Col>
      </Row>

      {/* Table hiển thị danh sách đơn hàng */}
      <Table
        columns={columns}
        dataSource={orders}
        loading={loading}
        rowKey="order_id"
        pagination={{
          pageSize: 10,
          showSizeChanger: true,
          showTotal: (total) => `Tổng ${total} đơn hàng`,
        }}
        bordered
      />
    </div>
  );
};

export default OrderPage;