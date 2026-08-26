package com.foodhub.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.foodhub.DAO.OrderItemDAO;
import com.foodhub.model.OrderItem;
import com.foodhub.utility.DBConnection;

public class OrderItemDAOImpl implements OrderItemDAO {

    private static final String INSERT_QUERY = "INSERT INTO `orderitem` (`order_id`, `menu_id`, `quantity`, `item_total`) VALUES (?, ?, ?, ?)";
    private static final String GET_QUERY = "SELECT * FROM `orderitem` WHERE `order_item_id` = ?";
    private static final String UPDATE_QUERY = "UPDATE `orderitem` SET `order_id` = ?, `menu_id` = ?, `quantity` = ?, `item_total` = ? WHERE `order_item_id` = ?";
    private static final String DELETE_QUERY = "DELETE FROM `orderitem` WHERE `order_item_id` = ?";
    private static final String GET_ALL_QUERY = "SELECT * FROM `orderitem`";

    @Override
    public void addOrderItem(OrderItem orderitem) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_QUERY)) {

            preparedStatement.setInt(1, orderitem.getOrderId());
            preparedStatement.setInt(2, orderitem.getMenuId());
            preparedStatement.setInt(3, orderitem.getQuantity());
            preparedStatement.setDouble(4, orderitem.getItemTotal());

            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public OrderItem getOrderItem(int id) {
        OrderItem orderitem = null;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(GET_QUERY)) {

            preparedStatement.setInt(1, id);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    orderitem = extractOrderItemFromResultSet(resultSet);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orderitem;
    }

    @Override
    public void updateOrderItem(OrderItem orderitem) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_QUERY)) {

            preparedStatement.setInt(1, orderitem.getOrderId());
            preparedStatement.setInt(2, orderitem.getMenuId());
            preparedStatement.setInt(3, orderitem.getQuantity());
            preparedStatement.setDouble(4, orderitem.getItemTotal());
            preparedStatement.setInt(5, orderitem.getOrderItemId());

            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteOrderItem(int id) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(DELETE_QUERY)) {

            preparedStatement.setInt(1, id);
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<OrderItem> getAllOrderItems() {
        List<OrderItem> orderItemList = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(GET_ALL_QUERY)) {

            while (resultSet.next()) {
                OrderItem orderitem = extractOrderItemFromResultSet(resultSet);
                orderItemList.add(orderitem);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orderItemList;
    }

    @Override
    public List<OrderItem> getOrderItemsByOrder(int orderId) {
        List<OrderItem> orderItemList = new ArrayList<>();
        String query = "SELECT * FROM `orderitem` WHERE `order_id` = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {

            preparedStatement.setInt(1, orderId);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    OrderItem orderitem = extractOrderItemFromResultSet(resultSet);
                    orderItemList.add(orderitem);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orderItemList;
    }

    private OrderItem extractOrderItemFromResultSet(ResultSet rs) throws SQLException {
        int orderItemId = rs.getInt("order_item_id");
        int orderId = rs.getInt("order_id");
        int menuId = rs.getInt("menu_id");
        int quantity = rs.getInt("quantity");
        double itemTotal = rs.getDouble("item_total");

        return new OrderItem(orderItemId, orderId, menuId, quantity, itemTotal);
    }
}
