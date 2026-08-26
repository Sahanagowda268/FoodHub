package com.foodhub.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.foodhub.DAO.RestaurantDAO;
import com.foodhub.model.Restaurant;
import com.foodhub.utility.DBConnection;

public class RestaurantDAOImpl implements RestaurantDAO {

    private static final String INSERT_QUERY =
            "INSERT INTO restaurant(name,cuisine_type,delivery_time,address,rating,is_active,image_path) VALUES(?,?,?,?,?,?,?)";

    private static final String GET_QUERY =
            "SELECT * FROM restaurant WHERE restaurant_id=?";

    private static final String UPDATE_QUERY =
            "UPDATE restaurant SET name=?,cuisine_type=?,delivery_time=?,address=?,rating=?,is_active=?,image_path=? WHERE restaurant_id=?";

    private static final String DELETE_QUERY =
            "DELETE FROM restaurant WHERE restaurant_id=?";

    private static final String GET_ALL_QUERY =
            "SELECT * FROM restaurant";

    @Override
    public void addRestaurant(Restaurant restaurant) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(INSERT_QUERY)) {

            ps.setString(1, restaurant.getName());
            ps.setString(2, restaurant.getCuisineType());
            ps.setInt(3, restaurant.getDeliveryTime());
            ps.setString(4, restaurant.getAddress());
            ps.setDouble(5, restaurant.getRating());
            ps.setBoolean(6, restaurant.getIsActive());
            ps.setString(7, restaurant.getImagePath());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Restaurant getRestaurant(int id) {

        Restaurant restaurant = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(GET_QUERY)) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                restaurant = extractRestaurantFromResultSet(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurant;
    }

    @Override
    public void updateRestaurant(Restaurant restaurant) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(UPDATE_QUERY)) {

            ps.setString(1, restaurant.getName());
            ps.setString(2, restaurant.getCuisineType());
            ps.setInt(3, restaurant.getDeliveryTime());
            ps.setString(4, restaurant.getAddress());
            ps.setDouble(5, restaurant.getRating());
            ps.setBoolean(6, restaurant.getIsActive());
            ps.setString(7, restaurant.getImagePath());
            ps.setInt(8, restaurant.getRestaurantId());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteRestaurant(int id) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(DELETE_QUERY)) {

            ps.setInt(1, id);

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Restaurant> getAllRestaurants() {

        List<Restaurant> restaurantList = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             Statement statement = connection.createStatement();
             ResultSet rs = statement.executeQuery(GET_ALL_QUERY)) {

            while (rs.next()) {

                Restaurant restaurant = extractRestaurantFromResultSet(rs);

                restaurantList.add(restaurant);

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurantList;
    }

    private Restaurant extractRestaurantFromResultSet(ResultSet rs) throws SQLException {

        int restaurantId = rs.getInt("restaurant_id");

        String name = rs.getString("name");

        String cuisineType = rs.getString("cuisine_type");

        int deliveryTime = rs.getInt("delivery_time");

        String address = rs.getString("address");

        double rating = rs.getDouble("rating");

        boolean isActive = rs.getBoolean("is_active");

        String imagePath = rs.getString("image_path");

        return new Restaurant(
                restaurantId,
                name,
                cuisineType,
                deliveryTime,
                address,
                rating,
                isActive,
                imagePath
        );
    }
}