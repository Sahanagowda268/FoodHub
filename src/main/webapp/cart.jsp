<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, com.foodhub.model.CartItem" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>FoodHub | Cart</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
<style>
body { font-family: 'Outfit', sans-serif; }
.page-container {
    max-width: 1400px;
    margin: 40px auto;
    padding: 0 5%;
}
.cart-layout {
    display: grid;
    grid-template-columns: 2fr 1fr;
    gap: 30px;
    align-items: start;
}
@media (max-width: 900px) {
    .cart-layout { grid-template-columns: 1fr; }
}
.cart-section {
    background: white;
    border-radius: 16px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.05);
    padding: 40px;
    border: 1px solid #eee;
}
h2 {
    color: var(--text);
    margin-bottom: 25px;
    font-weight: 800;
    font-size: 24px;
    border-bottom: 2px solid #eee;
    padding-bottom: 15px;
}
table { width: 100%; border-collapse: collapse; }
th, td { padding: 20px 10px; text-align: left; border-bottom: 1px solid #f5f5f5; }
th { color: #888; font-weight: 600; text-transform: uppercase; font-size: 13px; letter-spacing: 0.5px; }
.qty-controls { display: flex; align-items: center; gap: 10px; background: var(--border); padding: 5px; border-radius: 25px; width: fit-content; }
.qty-btn { width: 28px; height: 28px; background: white; border: 1px solid #ddd; border-radius: 50%; cursor: pointer; font-weight: bold; transition:0.3s; display: flex; align-items: center; justify-content: center; }
.qty-btn:hover { background: var(--primary); color: white; border-color: var(--primary); }
.qty-display { width: 20px; text-align: center; border: none; background: transparent; font-weight: 600; font-size: 15px; pointer-events: none;}
.remove-btn { background: #ffebee; border: none; color: var(--danger); font-weight: 600; cursor: pointer; font-size: 13px; transition: 0.3s; padding: 6px 12px; border-radius: 20px;}
.remove-btn:hover { background: var(--danger); color: white; }

.summary-row {
    display: flex;
    justify-content: space-between;
    margin-bottom: 15px;
    font-size: 16px;
    color: #555;
}
.summary-total {
    display: flex;
    justify-content: space-between;
    margin-top: 20px;
    padding-top: 20px;
    border-top: 2px solid #eee;
    font-size: 22px;
    font-weight: 800;
    color: var(--primary);
}
.btn-checkout { 
    display: block;
    width: 100%;
    text-align: center;
    margin-top: 30px; 
    font-size: 18px; 
    background: var(--primary); 
    color: white; 
    padding: 16px; 
    border-radius: 30px; 
    text-decoration: none; 
    font-weight: 700;
    transition: 0.3s;
    box-shadow: var(--shadow);
    border: none;
    cursor: pointer;
}
.btn-checkout:hover { background: var(--secondary); transform: translateY(-2px); box-shadow: 0 6px 20px rgba(46,125,50,0.4); }
.btn-outline {
    display: block;
    width: 100%;
    text-align: center;
    margin-top: 15px;
    padding: 16px;
    border-radius: 30px;
    text-decoration: none;
    font-weight: 700;
    border: 2px solid var(--primary);
    color: var(--primary);
    background: transparent;
    transition: 0.3s;
}
.btn-outline:hover { background: var(--primary); color: white; }
</style>
</head>
<body>
    
    <jsp:include page="navbar.jsp" />
    
    <div class="page-container">
        <% 
            Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
            double total = 0;
            if(cart != null && !cart.isEmpty()) {
                for(CartItem item : cart.values()) {
                    total += item.getSubTotal();
                }
        %>
        <div class="cart-layout">
            <!-- Left: Cart Items -->
            <div class="cart-section">
                <h2>Your Shopping Cart 🛒</h2>
                <table>
                    <tr>
                        <th>Item</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Subtotal</th>
                        <th>Action</th>
                    </tr>
                    <% for(CartItem item : cart.values()) { %>
                    <tr>
                        <td style="font-weight:700; color: #333; font-size:16px;"><%= item.getName() %></td>
                        <td style="color:#666;">₹<%= item.getPrice() %></td>
                        <td>
                            <div class="qty-controls">
                                <form action="${pageContext.request.contextPath}/cart" method="post" style="margin:0;">
                                    <input type="hidden" name="action" value="decrement">
                                    <input type="hidden" name="menuId" value="<%= item.getMenuId() %>">
                                    <button type="submit" class="qty-btn" <%= item.getQuantity() <= 1 ? "disabled" : "" %>>-</button>
                                </form>
                                <input type="text" class="qty-display" value="<%= item.getQuantity() %>" readonly>
                                <form action="${pageContext.request.contextPath}/cart" method="post" style="margin:0;">
                                    <input type="hidden" name="action" value="increment">
                                    <input type="hidden" name="menuId" value="<%= item.getMenuId() %>">
                                    <button type="submit" class="qty-btn">+</button>
                                </form>
                            </div>
                        </td>
                        <td style="font-weight:800; color:var(--primary); font-size:16px;">₹<%= item.getSubTotal() %></td>
                        <td>
                            <form action="${pageContext.request.contextPath}/cart" method="post" style="margin:0;">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="menuId" value="<%= item.getMenuId() %>">
                                <button type="submit" class="remove-btn">Remove</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </table>
            </div>

            <!-- Right: Order Summary -->
            <div class="cart-section" style="position: sticky; top: 100px;">
                <h2>Order Summary</h2>
                <div class="summary-row">
                    <span>Item Subtotal</span>
                    <span>₹<%= total %></span>
                </div>
                <div class="summary-row">
                    <span>Delivery Fee</span>
                    <span style="color:var(--success);">Free</span>
                </div>
                
                <div class="summary-total">
                    <span>Grand Total</span>
                    <span>₹<%= total %></span>
                </div>
                
                <a href="${pageContext.request.contextPath}/delivery.jsp" class="btn-checkout">Proceed to Checkout &rarr;</a>
                <a href="${pageContext.request.contextPath}/#restaurants-section" class="btn-outline">Add More Items</a>
            </div>
        </div>
        <% } else { %>
            <div class="cart-section" style="text-align:center; padding: 80px 20px;">
                <div style="font-size:60px; margin-bottom:20px;">🛒</div>
                <h3 style="color:var(--primary); margin-bottom:15px; font-size:28px;">Your cart is empty</h3>
                <p style="color:#666; font-size:18px; margin-bottom: 30px;">Looks like you haven't added anything delicious yet.</p>
                <a href="${pageContext.request.contextPath}/#restaurants-section" class="btn-checkout" style="max-width: 300px; margin: 0 auto;">Explore Restaurants</a>
            </div>
        <% } %>
    </div>
    
    <jsp:include page="footer.jsp" />
</body>
</html>
