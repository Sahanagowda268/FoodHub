package com.foodhub.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.foodhub.DAO.MenuDAO;
import com.foodhub.model.Menu;
import com.foodhub.utility.DBConnection;

public class MenuDAOImpl implements MenuDAO {

    private static final String INSERT_QUERY =
            "INSERT INTO menu (restaurant_id, item_name, description, price, is_available, image_path) VALUES (?, ?, ?, ?, ?, ?)";

    private static final String GET_QUERY =
            "SELECT * FROM menu WHERE menu_id = ?";

    private static final String UPDATE_QUERY =
            "UPDATE menu SET restaurant_id = ?, item_name = ?, description = ?, price = ?, is_available = ?, image_path = ? WHERE menu_id = ?";

    private static final String DELETE_QUERY =
            "DELETE FROM menu WHERE menu_id = ?";

    private static final String GET_ALL_QUERY =
            "SELECT * FROM menu";

    private static final String GET_BY_RESTAURANT_QUERY =
            "SELECT * FROM menu WHERE restaurant_id = ?";

    @Override
    public void addMenu(Menu menu) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_QUERY)) {

            preparedStatement.setInt(1, menu.getRestaurantId());
            preparedStatement.setString(2, menu.getItemName());
            preparedStatement.setString(3, menu.getDescription());
            preparedStatement.setDouble(4, menu.getPrice());
            preparedStatement.setBoolean(5, menu.getIsAvailable());
            preparedStatement.setString(6, menu.getImagePath());

            preparedStatement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Menu getMenu(int menuId) {

        Menu menu = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(GET_QUERY)) {

            preparedStatement.setInt(1, menuId);

            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                menu = extractMenuFromResultSet(resultSet);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menu;
    }

    @Override
    public void updateMenu(Menu menu) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_QUERY)) {

            preparedStatement.setInt(1, menu.getRestaurantId());
            preparedStatement.setString(2, menu.getItemName());
            preparedStatement.setString(3, menu.getDescription());
            preparedStatement.setDouble(4, menu.getPrice());
            preparedStatement.setBoolean(5, menu.getIsAvailable());
            preparedStatement.setString(6, menu.getImagePath());
            preparedStatement.setInt(7, menu.getMenuId());

            preparedStatement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteMenu(int menuId) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(DELETE_QUERY)) {

            preparedStatement.setInt(1, menuId);

            preparedStatement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Menu> getAllMenus() {

        List<Menu> menuList = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(GET_ALL_QUERY)) {

            while (resultSet.next()) {

                Menu menu = extractMenuFromResultSet(resultSet);

                menuList.add(menu);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menuList;
    }

    @Override
    public List<Menu> getMenusByRestaurant(int restaurantId) {

        List<Menu> menuList = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(GET_BY_RESTAURANT_QUERY)) {

            preparedStatement.setInt(1, restaurantId);

            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {

                Menu menu = extractMenuFromResultSet(resultSet);

                menuList.add(menu);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menuList;
    }

    private Menu extractMenuFromResultSet(ResultSet rs) throws SQLException {

        int menuId = rs.getInt("menu_id");
        int restaurantId = rs.getInt("restaurant_id");
        String itemName = rs.getString("item_name");
        String description = rs.getString("description");
        double price = rs.getDouble("price");
        boolean isAvailable = rs.getBoolean("is_available");
        String imagePath = rs.getString("image_path");

        return new Menu(
                menuId,
                restaurantId,
                itemName,
                description,
                price,
                isAvailable,
                imagePath
        );
    }
}