import { BrowserRouter, Routes, Route, Link } from 'react-router-dom';
import { Layout, Menu } from 'antd';
import ProductPage from './pages/ProductPage';
import OrderPage from './pages/OrderPage';

const { Header, Content, Footer } = Layout;

// Menu dẫn hướng
const items = [
  { key: '1', label: <Link to="/products">Sản phẩm</Link> },
  { key: '2', label: <Link to="/orders">Đơn hàng</Link> },
];

function App() {
  return (
    <BrowserRouter>
      <Layout className="layout" style={{ minHeight: '100vh' }}>
        <Header>
          <div className="logo" style={{ float: 'left', color: 'white', marginRight: 20, fontWeight: 'bold' }}>
            SHOP BTL
          </div>
          <Menu theme="dark" mode="horizontal" defaultSelectedKeys={['1']} items={items} />
        </Header>
        
        <Content style={{ padding: '0 50px', marginTop: 20 }}>
          <div className="site-layout-content" style={{ background: '#fff', padding: 24, minHeight: 380 }}>
            {/* Đây là nơi nội dung thay đổi khi bấm Menu */}
            <Routes>
              <Route path="/" element={<ProductPage />} />
              <Route path="/products" element={<ProductPage />} />
              <Route path="/orders" element={<OrderPage />} />
            </Routes>
          </div>
        </Content>
        
        <Footer style={{ textAlign: 'center' }}>BTL Nhóm ... ©2025 Created by React + PHP</Footer>
      </Layout>
    </BrowserRouter>
  );
}

export default App;