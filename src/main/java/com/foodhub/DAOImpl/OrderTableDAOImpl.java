package com.foodhub.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.foodhub.DAO.OrderTableDAO;
import com.foodhub.model.OrderTable;
import com.foodhub.utility.DBConnection;

public class OrderTableDAOImpl implements OrderTableDAO {

    private static final String INSERT_QUERY = "INSERT INTO `ordertable` (`user_id`, `restaurant_id`, `order_date`, `total_amount`, `status`, `payment_method`) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String GET_QUERY = "SELECT * FROM `ordertable` WHERE `order_id` = ?";
    private static final String UPDATE_QUERY = "UPDATE `ordertable` SET `user_id` = ?, `restaurant_id` = ?, `order_date` = ?, `total_amount` = ?, `status` = ?, `payment_method` = ? WHERE `order_id` = ?";
    private static final String DELETE_QUERY = "DELETE FROM `ordertable` WHERE `order_id` = ?";
    private static final String GET_ALL_QUERY = "SELECT * FROM `ordertable`";

    @Override
    public int addOrder(OrderTable ordertable) {
        int generatedId = -1;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_QUERY, Statement.RETURN_GENERATED_KEYS)) {

            preparedStatement.setInt(1, ordertable.getUserId());
            preparedStatement.setInt(2, ordertable.getRestaurantId());
            preparedStatement.setTimestamp(3, ordertable.getOrderDate());
            preparedStatement.setDouble(4, ordertable.getTotalAmount());
            preparedStatement.setString(5, ordertable.getStatus());
            preparedStatement.setString(6, ordertable.getPaymentMethod());

            int affectedRows = preparedStatement.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = preparedStatement.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return generatedId;
    }

    @Override
    public OrderTable getOrder(int id) {
        OrderTable ordertable = null;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(GET_QUERY)) {

            preparedStatement.setInt(1, id);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    ordertable = extractOrderTableFromResultSet(resultSet);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ordertable;
    }

    @Override
    public void updateOrder(OrderTable ordertable) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_QUERY)) {

            preparedStatement.setInt(1, ordertable.getUserId());
            preparedStatement.setInt(2, ordertable.getRestaurantId());
            preparedStatement.setTimestamp(3, ordertable.getOrderDate());
            preparedStatement.setDouble(4, ordertable.getTotalAmount());
            preparedStatement.setString(5, ordertable.getStatus());
            preparedStatement.setString(6, ordertable.getPaymentMethod());
            preparedStatement.setInt(7, ordertable.getOrderId());

            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteOrder(int id) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(DELETE_QUERY)) {

            preparedStatement.setInt(1, id);
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<OrderTable> getAllOrders() {
        List<OrderTable> orderTableList = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(GET_ALL_QUERY)) {

            while (resultSet.next()) {
                OrderTable ordertable = extractOrderTableFromResultSet(resultSet);
                orderTableList.add(ordertable);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orderTableList;
    }

    @Override
    public List<OrderTable> getOrdersByUser(int userId) {
        List<OrderTable> orderTableList = new ArrayList<>();
        String query = "SELECT * FROM `ordertable` WHERE `user_id` = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {

            preparedStatement.setInt(1, userId);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    OrderTable ordertable = extractOrderTableFromResultSet(resultSet);
                    orderTableList.add(ordertable);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orderTableList;
    }

    private OrderTable extractOrderTableFromResultSet(ResultSet rs) throws SQLException {
        int orderId = rs.getInt("order_id");
        int userId = rs.getInt("user_id");
        int restaurantId = rs.getInt("restaurant_id");
        Timestamp orderDate = rs.getTimestamp("order_date");
        double totalAmount = rs.getDouble("total_amount");
        String status = rs.getString("status");
        String paymentMethod = rs.getString("payment_method");

        return new OrderTable(orderId, userId, restaurantId, orderDate, totalAmount, status, paymentMethod);
    }
}
