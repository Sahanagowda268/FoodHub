package com.foodhub.DAOImpl;

import com.foodhub.DAO.OrderItemDAO;
import com.foodhub.model.OrderItem;
import com.foodhub.utility.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderItemDAOImpl implements OrderItemDAO {
    private static final String INSERT_QUERY = "INSERT INTO order_item (order_id, menu_id, quantity, item_total) VALUES (?, ?, ?, ?)";
    private static final String SELECT_BY_ID_QUERY = "SELECT * FROM order_item WHERE order_item_id = ?";
    private static final String UPDATE_QUERY = "UPDATE order_item SET order_id = ?, menu_id = ?, quantity = ?, item_total = ? WHERE order_item_id = ?";
    private static final String DELETE_QUERY = "DELETE FROM order_item WHERE order_item_id = ?";
    private static final String SELECT_ALL_QUERY = "SELECT * FROM order_item";
    private static final String SELECT_BY_ORDER_QUERY = "SELECT * FROM order_item WHERE order_id = ?";

    private OrderItem extractFromResultSet(ResultSet rs) throws SQLException {
        OrderItem item = new OrderItem();
        item.setOrderItemId(rs.getInt("order_item_id"));
        item.setOrderId(rs.getInt("order_id"));
        item.setMenuId(rs.getInt("menu_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setItemTotal(rs.getDouble("item_total"));
        return item;
    }

    @Override
    public void addOrderItem(OrderItem item) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(INSERT_QUERY, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, item.getOrderId());
            pstmt.setInt(2, item.getMenuId());
            pstmt.setInt(3, item.getQuantity());
            pstmt.setDouble(4, item.getItemTotal());
            pstmt.executeUpdate();
            
            ResultSet generatedKeys = pstmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                item.setOrderItemId(generatedKeys.getInt(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public OrderItem getOrderItem(int orderItemId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SELECT_BY_ID_QUERY)) {
            pstmt.setInt(1, orderItemId);
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
    public void updateOrderItem(OrderItem item) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(UPDATE_QUERY)) {
            pstmt.setInt(1, item.getOrderId());
            pstmt.setInt(2, item.getMenuId());
            pstmt.setInt(3, item.getQuantity());
            pstmt.setDouble(4, item.getItemTotal());
            pstmt.setInt(5, item.getOrderItemId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteOrderItem(int orderItemId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(DELETE_QUERY)) {
            pstmt.setInt(1, orderItemId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<OrderItem> getAllOrderItems() {
        List<OrderItem> items = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(SELECT_ALL_QUERY)) {
            while (rs.next()) {
                items.add(extractFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    @Override
    public List<OrderItem> getOrderItemsByOrder(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SELECT_BY_ORDER_QUERY)) {
            pstmt.setInt(1, orderId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                items.add(extractFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }
}
