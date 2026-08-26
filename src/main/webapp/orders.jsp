<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, java.text.SimpleDateFormat, com.foodhub.model.OrderTable" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>FoodHub | My Orders</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
<style>
body { font-family: 'Outfit', sans-serif; }
.page-container {
    max-width: 1400px;
    margin: 40px auto;
    padding: 0 5%;
    min-height: 50vh;
}
.page-title {
    font-size: 32px;
    font-weight: 800;
    color: var(--primary);
    margin-bottom: 30px;
    border-bottom: 2px solid #eee;
    padding-bottom: 15px;
}

/* Empty State */
.empty-state {
    text-align: center;
    padding: 80px 20px;
    background: white;
    border-radius: 16px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.05);
}
.empty-state h2 {
    color: var(--primary);
    margin-bottom: 10px;
    font-size: 28px;
}
.empty-state p {
    color: #666;
    margin-bottom: 25px;
    font-size: 16px;
}

/* Orders List */
.order-card {
    background: white;
    border-radius: 12px;
    padding: 25px;
    margin-bottom: 25px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.05);
    border: 1px solid #eee;
    transition: 0.3s;
}
.order-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 25px rgba(0,0,0,0.08);
}
.order-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1px solid #eee;
    padding-bottom: 15px;
    margin-bottom: 15px;
}
.order-id {
    font-size: 18px;
    font-weight: 700;
    color: var(--primary);
}
.order-date {
    color: #666;
    font-size: 14px;
}
.order-status {
    background: var(--accent);
    color: var(--primary);
    padding: 6px 12px;
    border-radius: 20px;
    font-weight: 700;
    font-size: 14px;
}
.order-body {
    display: flex;
    justify-content: space-between;
}
.order-details p {
    margin-bottom: 8px;
    color: var(--text);
    font-size: 15px;
}
.order-details b { color: #666; }
.order-total {
    text-align: right;
}
.order-total span {
    display: block;
    font-size: 24px;
    font-weight: 800;
    color: var(--primary);
    margin-top: 5px;
}
@media (max-width: 600px) {
    .order-body { flex-direction: column; gap: 15px; }
    .order-total { text-align: left; }
}
</style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="page-container">
        <h1 class="page-title">📦 My Orders</h1>

        <%
            List<OrderTable> orders = (List<OrderTable>) request.getAttribute("orders");
            Map<Integer, String> restaurantNames = (Map<Integer, String>) request.getAttribute("restaurantNames");
            SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");

            if (orders == null || orders.isEmpty()) {
        %>
            <div class="empty-state">
                <div style="font-size:60px; margin-bottom:20px;">🛵</div>
                <h2>No orders yet.</h2>
                <p>Your delicious journey starts here. Explore restaurants and place your first order!</p>
                <a href="${pageContext.request.contextPath}/#restaurants-section" class="btn btn-primary">Explore Restaurants</a>
            </div>
        <%
            } else {
                for (OrderTable order : orders) {
                    String restaurantName = restaurantNames.get(order.getRestaurantId());
        %>
            <div class="order-card">
                <div class="order-header">
                    <div>
                        <span class="order-id">Order #<%= order.getOrderId() %></span>
                        <span class="order-date"> • <%= sdf.format(order.getOrderDate()) %></span>
                    </div>
                    <span class="order-status"><%= order.getStatus() %></span>
                </div>
                <div class="order-body">
                    <div class="order-details">
                        <p><b>Restaurant:</b> <%= restaurantName %></p>
                        <p><b>Payment Method:</b> <%= order.getPaymentMethod() %></p>
                    </div>
                    <div class="order-total">
                        <b>Total Amount</b>
                        <span>₹<%= order.getTotalAmount() %></span>
                    </div>
                </div>
            </div>
        <% 
                } 
            }
        %>
    </div>

    <jsp:include page="footer.jsp" />

</body>
</html>
