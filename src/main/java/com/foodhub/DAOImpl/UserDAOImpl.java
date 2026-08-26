package com.foodhub.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.foodhub.DAO.UserDAO;
import com.foodhub.model.User;
import com.foodhub.utility.DBConnection;

public class UserDAOImpl implements UserDAO {

    private static final String INSERT_QUERY = "INSERT INTO `user` (`user_name`, `password`, `email`, `address`, `role`, `created_data`, `last_logindate`, `phone`, `gender`, `date_of_birth`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String GET_QUERY = "SELECT * FROM `user` WHERE `user_id` = ?";
    private static final String UPDATE_QUERY = "UPDATE `user` SET `user_name` = ?, `password` = ?, `email` = ?, `address` = ?, `role` = ?, `created_data` = ?, `last_logindate` = ?, `phone` = ?, `gender` = ?, `date_of_birth` = ? WHERE `user_id` = ?";
    private static final String UPDATE_PROFILE_QUERY = "UPDATE `user` SET `user_name` = ?, `phone` = ?, `address` = ?, `gender` = ?, `date_of_birth` = ? WHERE `user_id` = ?";
    private static final String DELETE_QUERY = "DELETE FROM `user` WHERE `user_id` = ?";
    private static final String GET_ALL_QUERY = "SELECT * FROM `user`";

    @Override
    public void addUser(User user) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_QUERY)) {

            preparedStatement.setString(1, user.getUsername());
            preparedStatement.setString(2, user.getPassword());
            preparedStatement.setString(3, user.getEmail());
            preparedStatement.setString(4, user.getAddress());
            preparedStatement.setString(5, user.getRole());
            preparedStatement.setTimestamp(6, user.getCreatedDate());
            preparedStatement.setTimestamp(7, user.getLastLoginDate());
            preparedStatement.setString(8, user.getPhone());
            preparedStatement.setString(9, user.getGender());
            preparedStatement.setDate(10, user.getDateOfBirth());

            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public User getUser(int id) {
        User user = null;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(GET_QUERY)) {

            preparedStatement.setInt(1, id);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    user = extractUserFromResultSet(resultSet);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    @Override
    public void updateUser(User user) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_QUERY)) {

            preparedStatement.setString(1, user.getUsername());
            preparedStatement.setString(2, user.getPassword());
            preparedStatement.setString(3, user.getEmail());
            preparedStatement.setString(4, user.getAddress());
            preparedStatement.setString(5, user.getRole());
            preparedStatement.setTimestamp(6, user.getCreatedDate());
            preparedStatement.setTimestamp(7, user.getLastLoginDate());
            preparedStatement.setString(8, user.getPhone());
            preparedStatement.setString(9, user.getGender());
            preparedStatement.setDate(10, user.getDateOfBirth());
            preparedStatement.setInt(11, user.getUserId());

            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void updateUserProfile(User user) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_PROFILE_QUERY)) {

            preparedStatement.setString(1, user.getUsername());
            preparedStatement.setString(2, user.getPhone());
            preparedStatement.setString(3, user.getAddress());
            preparedStatement.setString(4, user.getGender());
            preparedStatement.setDate(5, user.getDateOfBirth());
            preparedStatement.setInt(6, user.getUserId());

            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteUser(int id) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(DELETE_QUERY)) {

            preparedStatement.setInt(1, id);
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<User> getAllUsers() {
        List<User> userList = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(GET_ALL_QUERY)) {

            while (resultSet.next()) {
                User user = extractUserFromResultSet(resultSet);
                userList.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return userList;
    }

    @Override
    public User getUserByEmail(String email) {
        User user = null;
        String query = "SELECT * FROM `user` WHERE `email` = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {

            preparedStatement.setString(1, email);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    user = extractUserFromResultSet(resultSet);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        int userId = rs.getInt("user_id");
        String username = rs.getString("user_name");
        String password = rs.getString("password");
        String email = rs.getString("email");
        String address = rs.getString("address");
        String role = rs.getString("role");
        Timestamp createdDate = rs.getTimestamp("created_data");
        Timestamp lastLoginDate = rs.getTimestamp("last_logindate");
        String phone = rs.getString("phone");
        String gender = rs.getString("gender");
        java.sql.Date dateOfBirth = rs.getDate("date_of_birth");

        return new User(userId, username, password, email, address, role, createdDate, lastLoginDate, phone, gender, dateOfBirth);
    }
}
