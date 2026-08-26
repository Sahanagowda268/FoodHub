package com.foodhub.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.Map;

import com.foodhub.DAOImpl.OrderItemDAOImpl;
import com.foodhub.DAOImpl.OrderTableDAOImpl;
import com.foodhub.model.CartItem;
import com.foodhub.model.OrderItem;
import com.foodhub.model.OrderTable;
import com.foodhub.model.User;
import com.foodhub.utility.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {
    
    private static volatile boolean tablesChecked = false;
    
    /**
     * Ensures the ordertable and orderitem tables exist in the database.
     * Runs only once per application lifecycle.
     */
    private void ensureTablesExist() {
        if (tablesChecked) return;
        synchronized (OrderServlet.class) {
            if (tablesChecked) return;
            try (Connection conn = DBConnection.getConnection();
                 Statement stmt = conn.createStatement()) {
                
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
                
                tablesChecked = true;
                System.out.println("OrderServlet: Database tables verified/created successfully.");
            } catch (Exception e) {
                System.err.println("OrderServlet: Failed to create tables: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("loggedInUser");
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart.jsp");
            return;
        }

        String deliveryAddress = req.getParameter("deliveryAddress");
        if (deliveryAddress == null || deliveryAddress.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/delivery.jsp");
            return;
        }

        String paymentMethod = req.getParameter("paymentMethod");
        if(paymentMethod == null) paymentMethod = "Cash On Delivery";
        
        // Ensure database tables exist before attempting insert
        ensureTablesExist();
        
        double totalAmount = 0;
        int restaurantId = -1;
        for (CartItem item : cart.values()) {
            totalAmount += item.getSubTotal();
            restaurantId = item.getRestaurantId();
        }
        
        OrderTable order = new OrderTable(
            0,
            user.getUserId(),
            restaurantId,
            Timestamp.from(Instant.now()),
            totalAmount,
            "Pending",
            paymentMethod
        );
        
        OrderTableDAOImpl orderDAO = new OrderTableDAOImpl();
        int orderId = orderDAO.addOrder(order);
        
        if (orderId != -1) {
            // Order saved successfully — now save order items
            OrderItemDAOImpl orderItemDAO = new OrderItemDAOImpl();
            for (CartItem item : cart.values()) {
                OrderItem orderItem = new OrderItem(
                    0,
                    orderId,
                    item.getMenuId(),
                    item.getQuantity(),
                    item.getSubTotal()
                );
                orderItemDAO.addOrderItem(orderItem);
            }
            
            // Clear cart only after successful save
            session.removeAttribute("cart");
            resp.sendRedirect(req.getContextPath() + "/order-success.jsp?orderId=" + orderId);
        } else {
            // Order failed to save — redirect back to checkout with error
            // Do NOT clear the cart so the user can retry
            resp.sendRedirect(req.getContextPath() + "/checkout.jsp?error=order_failed");
        }
    }
}
