<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.foodhub.DAOImpl.OrderTableDAOImpl, com.foodhub.model.OrderTable, com.foodhub.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>FoodHub | Success</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
<style>
body { font-family: 'Outfit', sans-serif; background-color: #f8f9fa; }
.success-page-container {
    max-width: 1000px;
    margin: 60px auto;
    padding: 0 20px;
}
.success-banner {
    background-color: #e8f5e9;
    border-radius: 16px;
    padding: 40px 20px;
    text-align: center;
    margin-bottom: 30px;
    border: 1px solid #c8e6c9;
}
.success-icon {
    width: 70px;
    height: 70px;
    background-color: #4caf50;
    color: white;
    font-size: 40px;
    line-height: 70px;
    border-radius: 50%;
    margin: 0 auto 20px auto;
    box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
}
.success-banner h2 { color: #2e7d32; margin-bottom: 10px; font-size: 28px; font-weight: 800; }
.success-banner p { color: #388e3c; font-size: 16px; margin-bottom: 15px; }
.success-banner .order-id {
    display: inline-block;
    background: #c8e6c9;
    color: #1b5e20;
    padding: 8px 20px;
    border-radius: 50px;
    font-weight: 700;
    font-size: 15px;
}

.receipt-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 30px;
}
@media (max-width: 768px) {
    .receipt-grid { grid-template-columns: 1fr; }
}

.receipt-card {
    background: white;
    border-radius: 16px;
    padding: 35px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.04);
    border: 1px solid #f0f0f0;
}
.receipt-card h3 {
    font-size: 18px;
    font-weight: 700;
    margin-bottom: 25px;
    color: #333;
    display: flex;
    align-items: center;
    gap: 10px;
    border-bottom: 1px solid #f0f0f0;
    padding-bottom: 15px;
}

.detail-row {
    display: flex;
    justify-content: space-between;
    margin-bottom: 20px;
}
.detail-row span { color: #777; font-size: 15px; }
.detail-row b { color: #333; font-size: 15px; text-align: right; max-width: 60%; word-wrap: break-word; }

.detail-total {
    display: flex;
    justify-content: space-between;
    margin-top: 25px;
    padding-top: 20px;
    border-top: 2px dashed #eee;
    font-size: 18px;
    font-weight: 800;
    color: #333;
}

.btn-continue {
    display: block;
    width: 100%;
    background-color: #ef4444;
    color: white;
    text-align: center;
    padding: 16px;
    border-radius: 8px;
    font-weight: 700;
    font-size: 16px;
    text-decoration: none;
    margin-top: 30px;
    transition: 0.3s;
    border: none;
}
.btn-continue:hover {
    background-color: #dc2626;
    transform: translateY(-2px);
}
</style>
</head>
<body>
    <jsp:include page="navbar.jsp" />
    
    <div class="success-page-container">
        
        <%
            String orderIdStr = request.getParameter("orderId");
            User user = (User) session.getAttribute("loggedInUser");
            OrderTable order = null;
            if(orderIdStr != null && user != null) {
                try {
                    int orderId = Integer.parseInt(orderIdStr);
                    OrderTableDAOImpl orderDao = new OrderTableDAOImpl();
                    OrderTable fetchedOrder = orderDao.getOrder(orderId);
                    if(fetchedOrder != null && fetchedOrder.getUserId() == user.getUserId()) {
                        order = fetchedOrder;
                    }
                } catch (Exception e) {}
            }
            
            if (order != null) {
        %>
        
        <!-- Banner -->
        <div class="success-banner">
            <div class="success-icon">✓</div>
            <h2>Order Placed Successfully!</h2>
            <p>Thank you for ordering with FoodHub. Your order is confirmed & being prepared fresh.</p>
            <div class="order-id">🧾 Order ID: #<%= order.getOrderId() %></div>
        </div>
        
        <!-- Two Columns -->
        <div class="receipt-grid">
            
            <!-- Left: Delivery Details -->
            <div class="receipt-card">
                <h3>🚚 Delivery Details</h3>
                <div class="detail-row"><span>Customer Name</span> <b><%= user.getUsername() %></b></div>
                <div class="detail-row"><span>Phone Number</span> <b><%= user.getPhone() != null && !user.getPhone().isEmpty() ? user.getPhone() : "Not provided" %></b></div>
                <div class="detail-row"><span>Delivery Address</span> <b><%= user.getAddress() %></b></div>
                <div class="detail-row"><span>Payment Method</span> <b style="color:var(--primary);"><%= order.getPaymentMethod() %></b></div>
            </div>
            
            <!-- Right: Receipt Summary -->
            <div class="receipt-card">
                <h3>📋 Receipt Summary</h3>
                <div class="detail-row"><span>Items Subtotal</span> <b>₹<%= String.format("%.2f", order.getTotalAmount() - 30.0) %></b></div>
                <div class="detail-row"><span>Delivery Fee</span> <b>₹30.00</b></div>
                
                <div class="detail-total">
                    <span>Total Amount Paid</span> 
                    <span style="color:#ef4444;">₹<%= String.format("%.2f", order.getTotalAmount()) %></span>
                </div>
                
                <a href="${pageContext.request.contextPath}/" class="btn-continue">🏠 Continue Shopping</a>
            </div>
            
        </div>
        
        <% } else { %>
            <div class="success-banner" style="background:#fff3f3; border-color:#ffcdd2;">
                <h2 style="color:#d32f2f;">Order Not Found</h2>
                <p style="color:#c62828;">We couldn't retrieve your order details. Please place an order from your cart first.</p>
                <a href="${pageContext.request.contextPath}/" class="btn-continue" style="width: auto; display: inline-block; padding: 12px 30px;">Return Home</a>
            </div>
        <% } %>
        
    </div>
    
    <jsp:include page="footer.jsp" />
</body>
</html>
