package com.foodhub.DAOImpl;

import com.foodhub.DAO.RestaurantDAO;
import com.foodhub.model.Restaurant;
import com.foodhub.utility.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RestaurantDAOImpl implements RestaurantDAO {
    private static final String INSERT_QUERY = "INSERT INTO restaurant (name, cuisine_type, delivery_time, address, rating, is_active, image_path) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String SELECT_BY_ID_QUERY = "SELECT * FROM restaurant WHERE restaurant_id = ?";
    private static final String UPDATE_QUERY = "UPDATE restaurant SET name = ?, cuisine_type = ?, delivery_time = ?, address = ?, rating = ?, is_active = ?, image_path = ? WHERE restaurant_id = ?";
    private static final String DELETE_QUERY = "DELETE FROM restaurant WHERE restaurant_id = ?";
    private static final String SELECT_ALL_QUERY = "SELECT * FROM restaurant";

    private Restaurant extractFromResultSet(ResultSet rs) throws SQLException {
        Restaurant restaurant = new Restaurant();
        restaurant.setRestaurantId(rs.getInt("restaurant_id"));
        restaurant.setName(rs.getString("name"));
        restaurant.setCuisineType(rs.getString("cuisine_type"));
        restaurant.setDeliveryTime(rs.getInt("delivery_time"));
        restaurant.setAddress(rs.getString("address"));
        restaurant.setRating(rs.getFloat("rating"));
        restaurant.setActive(rs.getBoolean("is_active"));
        restaurant.setImagePath(rs.getString("image_path"));
        return restaurant;
    }

    @Override
    public void addRestaurant(Restaurant restaurant) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(INSERT_QUERY)) {
            pstmt.setString(1, restaurant.getName());
            pstmt.setString(2, restaurant.getCuisineType());
            pstmt.setInt(3, restaurant.getDeliveryTime());
            pstmt.setString(4, restaurant.getAddress());
            pstmt.setFloat(5, restaurant.getRating());
            pstmt.setBoolean(6, restaurant.isActive());
            pstmt.setString(7, restaurant.getImagePath());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Restaurant getRestaurant(int restaurantId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SELECT_BY_ID_QUERY)) {
            pstmt.setInt(1, restaurantId);
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
    public void updateRestaurant(Restaurant restaurant) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(UPDATE_QUERY)) {
            pstmt.setString(1, restaurant.getName());
            pstmt.setString(2, restaurant.getCuisineType());
            pstmt.setInt(3, restaurant.getDeliveryTime());
            pstmt.setString(4, restaurant.getAddress());
            pstmt.setFloat(5, restaurant.getRating());
            pstmt.setBoolean(6, restaurant.isActive());
            pstmt.setString(7, restaurant.getImagePath());
            pstmt.setInt(8, restaurant.getRestaurantId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteRestaurant(int restaurantId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(DELETE_QUERY)) {
            pstmt.setInt(1, restaurantId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Restaurant> getAllRestaurants() {
        List<Restaurant> restaurants = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(SELECT_ALL_QUERY)) {
            while (rs.next()) {
                restaurants.add(extractFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return restaurants;
    }
}
