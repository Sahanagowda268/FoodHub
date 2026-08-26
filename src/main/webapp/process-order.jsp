<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.Map, com.foodhub.model.CartItem, com.foodhub.model.User, com.foodhub.utility.DBConnection" %>
<%
    // ===== PROCESS ORDER JSP =====
    // This JSP handles the Place Order form submission.
    // It creates missing tables, inserts the order, and redirects to the success page.
    // JSPs auto-compile without a Tomcat restart, unlike Java servlets.

    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
    if (cart == null || cart.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/cart.jsp");
        return;
    }

    String deliveryAddress = request.getParameter("deliveryAddress");
    if (deliveryAddress == null || deliveryAddress.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/delivery.jsp");
        return;
    }

    String paymentMethod = request.getParameter("paymentMethod");
    if (paymentMethod == null) paymentMethod = "Cash On Delivery";

    double totalAmount = 0;
    int restaurantId = -1;
    for (CartItem item : cart.values()) {
        totalAmount += item.getSubTotal();
        restaurantId = item.getRestaurantId();
    }

    int generatedOrderId = -1;
    Connection conn = null;

    try {
        conn = DBConnection.getConnection();

        // Step 1: Create tables if they don't exist
        Statement stmt = conn.createStatement();
        stmt.executeUpdate(
            "CREATE TABLE IF NOT EXISTS ordertable (" +
            "order_id INT AUTO_INCREMENT PRIMARY KEY, " +
            "user_id INT, " +
            "restaurant_id INT, " +
            "order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
            "total_amount DECIMAL(10,2), " +
            "status VARCHAR(50), " +
            "payment_method VARCHAR(50)" +
            ")"
        );
        stmt.executeUpdate(
            "CREATE TABLE IF NOT EXISTS orderitem (" +
            "order_item_id INT AUTO_INCREMENT PRIMARY KEY, " +
            "order_id INT, " +
            "menu_id INT, " +
            "quantity INT, " +
            "item_total DECIMAL(10,2)" +
            ")"
        );
        stmt.close();

        // Step 2: Insert the order
        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO ordertable (user_id, restaurant_id, order_date, total_amount, status, payment_method) VALUES (?, ?, NOW(), ?, ?, ?)",
            Statement.RETURN_GENERATED_KEYS
        );
        ps.setInt(1, user.getUserId());
        ps.setInt(2, restaurantId);
        ps.setDouble(3, totalAmount);
        ps.setString(4, "Pending");
        ps.setString(5, paymentMethod);

        int rows = ps.executeUpdate();
        if (rows > 0) {
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) {
                generatedOrderId = keys.getInt(1);
            }
            keys.close();
        }
        ps.close();

        // Step 3: Insert order items
        if (generatedOrderId != -1) {
            PreparedStatement itemPs = conn.prepareStatement(
                "INSERT INTO orderitem (order_id, menu_id, quantity, item_total) VALUES (?, ?, ?, ?)"
            );
            for (CartItem item : cart.values()) {
                itemPs.setInt(1, generatedOrderId);
                itemPs.setInt(2, item.getMenuId());
                itemPs.setInt(3, item.getQuantity());
                itemPs.setDouble(4, item.getSubTotal());
                itemPs.addBatch();
            }
            itemPs.executeBatch();
            itemPs.close();

            // Step 4: Clear cart ONLY after successful insert
            session.removeAttribute("cart");
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (conn != null) {
            try { conn.close(); } catch (Exception ignored) {}
        }
    }

    // Step 5: Redirect
    if (generatedOrderId != -1) {
        response.sendRedirect(request.getContextPath() + "/order-success.jsp?orderId=" + generatedOrderId);
    } else {
        response.sendRedirect(request.getContextPath() + "/checkout.jsp?error=order_failed");
    }
%>
