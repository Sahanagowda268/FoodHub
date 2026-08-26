package com.foodhub.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.foodhub.DAO.FavouriteDAO;
import com.foodhub.model.Favourite;
import com.foodhub.utility.DBConnection;

public class FavouriteDAOImpl implements FavouriteDAO {

    private static final String INSERT_QUERY = "INSERT INTO favourite (user_id, menu_id) VALUES (?, ?)";
    private static final String DELETE_QUERY = "DELETE FROM favourite WHERE user_id = ? AND menu_id = ?";
    private static final String GET_BY_USER_QUERY = "SELECT * FROM favourite WHERE user_id = ?";
    private static final String CHECK_QUERY = "SELECT * FROM favourite WHERE user_id = ? AND menu_id = ?";

    @Override
    public void addFavourite(int userId, int menuId) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_QUERY)) {
            
            preparedStatement.setInt(1, userId);
            preparedStatement.setInt(2, menuId);
            preparedStatement.executeUpdate();
            
        } catch (SQLException e) {
            // Might be duplicate entry, which is fine
            e.printStackTrace();
        }
    }

    @Override
    public void removeFavourite(int userId, int menuId) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(DELETE_QUERY)) {
            
            preparedStatement.setInt(1, userId);
            preparedStatement.setInt(2, menuId);
            preparedStatement.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Favourite> getFavouritesByUser(int userId) {
        List<Favourite> list = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(GET_BY_USER_QUERY)) {
            
            preparedStatement.setInt(1, userId);
            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    int favId = 0;
                    try {
                        favId = rs.getInt("favourite_id");
                    } catch (SQLException ignore) {}
                    list.add(new Favourite(favId, rs.getInt("user_id"), rs.getInt("menu_id")));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean isFavourite(int userId, int menuId) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(CHECK_QUERY)) {
            
            preparedStatement.setInt(1, userId);
            preparedStatement.setInt(2, menuId);
            try (ResultSet rs = preparedStatement.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
