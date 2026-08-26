package com.foodhub.DAOImpl;

import com.foodhub.DAO.OrderTableDAO;
import com.foodhub.model.OrderTable;
import com.foodhub.utility.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderTableDAOImpl implements OrderTableDAO {
    private static final String INSERT_QUERY = "INSERT INTO order_table (user_id, restaurant_id, total_amount, status, payment_mode, order_date) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String SELECT_BY_ID_QUERY = "SELECT * FROM order_table WHERE order_id = ?";
    private static final String UPDATE_QUERY = "UPDATE order_table SET user_id = ?, restaurant_id = ?, total_amount = ?, status = ?, payment_mode = ?, order_date = ? WHERE order_id = ?";
    private static final String DELETE_QUERY = "DELETE FROM order_table WHERE order_id = ?";
    private static final String SELECT_ALL_QUERY = "SELECT * FROM order_table";
    private static final String SELECT_BY_USER_QUERY = "SELECT * FROM order_table WHERE user_id = ?";

    private OrderTable extractFromResultSet(ResultSet rs) throws SQLException {
        OrderTable order = new OrderTable();
        order.setOrderId(rs.getInt("order_id"));
        order.setUserId(rs.getInt("user_id"));
        order.setRestaurantId(rs.getInt("restaurant_id"));
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setPaymentMode(rs.getString("payment_mode"));
        order.setOrderDate(rs.getTimestamp("order_date"));
        return order;
    }

    @Override
    public void addOrder(OrderTable order) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(INSERT_QUERY, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, order.getUserId());
            pstmt.setInt(2, order.getRestaurantId());
            pstmt.setDouble(3, order.getTotalAmount());
            pstmt.setString(4, order.getStatus());
            pstmt.setString(5, order.getPaymentMode());
            pstmt.setTimestamp(6, new Timestamp(order.getOrderDate().getTime()));
            pstmt.executeUpdate();
            
            ResultSet generatedKeys = pstmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                order.setOrderId(generatedKeys.getInt(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public OrderTable getOrder(int orderId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SELECT_BY_ID_QUERY)) {
            pstmt.setInt(1, orderId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public void updateOrder(OrderTable order) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(UPDATE_QUERY)) {
            pstmt.setInt(1, order.getUserId());
            pstmt.setInt(2, order.getRestaurantId());
            pstmt.setDouble(3, order.getTotalAmount());
            pstmt.setString(4, order.getStatus());
            pstmt.setString(5, order.getPaymentMode());
            pstmt.setTimestamp(6, new Timestamp(order.getOrderDate().getTime()));
            pstmt.setInt(7, order.getOrderId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteOrder(int orderId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(DELETE_QUERY)) {
            pstmt.setInt(1, orderId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<OrderTable> getAllOrders() {
        List<OrderTable> orders = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(SELECT_ALL_QUERY)) {
            while (rs.next()) {
                orders.add(extractFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    @Override
    public List<OrderTable> getOrdersByUser(int userId) {
        List<OrderTable> orders = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SELECT_BY_USER_QUERY)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                orders.add(extractFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
}
