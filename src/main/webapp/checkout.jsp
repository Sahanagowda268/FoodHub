<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, com.foodhub.model.CartItem, com.foodhub.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>FoodHub | Checkout</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
<style>
body { font-family: 'Outfit', sans-serif; }
.page-container {
    max-width: 1200px;
    margin: 40px auto;
    padding: 0 5%;
}
.checkout-container {
    background: white;
    border-radius: 16px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.05);
    padding: 40px;
    text-align: center;
}
h2 {
    color: var(--primary);
    margin-bottom: 25px;
    font-weight: 800;
    font-size: 28px;
    border-bottom: 2px solid #eee;
    padding-bottom: 15px;
}
.info {
    margin-bottom: 30px;
    font-size: 16px;
    color: var(--text);
    background: var(--accent);
    padding: 25px;
    border-radius: 12px;
    border: 1px solid var(--border);
}
.info p { margin-bottom: 10px; }
.info p:last-child { margin-bottom: 0; }
.total {
    font-size: 24px;
    font-weight: 800;
    color: var(--primary);
    margin: 25px 0;
    text-align: center;
}
table { width: 100%; border-collapse: collapse; margin-bottom: 25px; margin-left: auto; margin-right: auto; }
th, td { padding: 15px; text-align: center; border-bottom: 1px solid #eee; }
th { color: #666; font-weight: 600; text-transform: uppercase; font-size: 14px; letter-spacing: 0.5px; }
.btn-success {
    background: var(--primary);
    color: white;
    padding: 16px;
    border-radius: 30px;
    font-weight: 700;
    font-size: 18px;
    transition: 0.3s;
    border: none;
    box-shadow: var(--shadow);
    cursor: pointer;
}
.btn-success:hover {
    background: var(--secondary);
    transform: translateY(-2px);
}
.form-control {
    padding: 14px;
    border-radius: 8px;
    border: 1px solid #ddd;
    width: 100%;
    margin-top: 10px;
    font-family: inherit;
    font-size: 16px;
}
.bg-delivery {
    background-image: url('${pageContext.request.contextPath}/images/delivery-bg.jpg');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    background-attachment: fixed;
}
</style>
</head>
<body class="bg-delivery">
    <%
        User user = (User) session.getAttribute("loggedInUser");
        if(user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=checkout.jsp");
            return;
        }
        
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if(cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart.jsp");
            return;
        }
        
        double total = 0;
        for(CartItem item : cart.values()) {
            total += item.getSubTotal();
        }
        
        String addressType = request.getParameter("addressType");
        String defaultAddress = request.getParameter("defaultAddress");
        String customAddress = request.getParameter("customAddress");
        
        String deliveryAddress = user.getAddress(); // fallback
        if ("custom".equals(addressType) && customAddress != null && !customAddress.trim().isEmpty()) {
            deliveryAddress = customAddress;
        } else if ("default".equals(addressType) && defaultAddress != null) {
            deliveryAddress = defaultAddress;
        }
    %>
    <jsp:include page="navbar.jsp" />
    
    <% if ("order_failed".equals(request.getParameter("error"))) { %>
    <div style="background:#f8d7da; color:#721c24; padding:15px; margin:20px auto; max-width:1200px; border-radius:8px; text-align:center; font-weight:700;">
        ⚠️ Order could not be placed. Please try again.
    </div>
    <% } %>
    
    <div class="page-container">
        <div class="checkout-container">
            <h2>Checkout 💳</h2>
            <div class="info">
                <p><strong>Deliver to:</strong> <%= user.getUsername() %></p>
                <p><strong>Delivery Address:</strong> <%= deliveryAddress %></p>
            </div>
            
            <table>
                <tr>
                    <th>Item</th>
                    <th>Qty</th>
                    <th>Subtotal</th>
                </tr>
                <% for(CartItem item : cart.values()) { %>
                <tr>
                    <td style="font-weight:600; color:var(--text);"><%= item.getName() %></td>
                    <td><%= item.getQuantity() %></td>
                    <td style="color:var(--primary); font-weight:700;">₹<%= item.getSubTotal() %></td>
                </tr>
                <% } %>
            </table>
            
            <div class="total">
                Amount to Pay: ₹<%= total %>
            </div>
            
            <form action="${pageContext.request.contextPath}/process-order.jsp" method="post">
                <input type="hidden" name="deliveryAddress" value="<%= deliveryAddress %>">
                <div class="form-group" style="margin-bottom: 25px;">
                    <label for="paymentMethod" style="font-weight:700; font-size:16px; color:#333;">Select Payment Method</label>
                    <select name="paymentMethod" id="paymentMethod" class="form-control" required>
                        <option value="Cash On Delivery">Cash On Delivery (COD)</option>
                        <option value="Credit Card">Credit Card</option>
                        <option value="UPI">UPI</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-success" style="width:100%;">Place Order</button>
            </form>
        </div>
    </div>
    
    <jsp:include page="footer.jsp" />
</body>
</html>
