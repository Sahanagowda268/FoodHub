package com.foodhub.DAOImpl;

import com.foodhub.DAO.MenuDAO;
import com.foodhub.model.Menu;
import com.foodhub.utility.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MenuDAOImpl implements MenuDAO {
    private static final String INSERT_QUERY = "INSERT INTO menu (restaurant_id, name, description, price, is_available, image_path) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String SELECT_BY_ID_QUERY = "SELECT * FROM menu WHERE menu_id = ?";
    private static final String UPDATE_QUERY = "UPDATE menu SET restaurant_id = ?, name = ?, description = ?, price = ?, is_available = ?, image_path = ? WHERE menu_id = ?";
    private static final String DELETE_QUERY = "DELETE FROM menu WHERE menu_id = ?";
    private static final String SELECT_ALL_QUERY = "SELECT * FROM menu";
    private static final String SELECT_BY_RESTAURANT_QUERY = "SELECT * FROM menu WHERE restaurant_id = ?";

    private Menu extractFromResultSet(ResultSet rs) throws SQLException {
        Menu menu = new Menu();
        menu.setMenuId(rs.getInt("menu_id"));
        menu.setRestaurantId(rs.getInt("restaurant_id"));
        menu.setName(rs.getString("name"));
        menu.setDescription(rs.getString("description"));
        menu.setPrice(rs.getDouble("price"));
        menu.setAvailable(rs.getBoolean("is_available"));
        menu.setImagePath(rs.getString("image_path"));
        return menu;
    }

    @Override
    public void addMenu(Menu menu) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(INSERT_QUERY)) {
            pstmt.setInt(1, menu.getRestaurantId());
            pstmt.setString(2, menu.getName());
            pstmt.setString(3, menu.getDescription());
            pstmt.setDouble(4, menu.getPrice());
            pstmt.setBoolean(5, menu.isAvailable());
            pstmt.setString(6, menu.getImagePath());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Menu getMenu(int menuId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SELECT_BY_ID_QUERY)) {
            pstmt.setInt(1, menuId);
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
    public void updateMenu(Menu menu) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(UPDATE_QUERY)) {
            pstmt.setInt(1, menu.getRestaurantId());
            pstmt.setString(2, menu.getName());
            pstmt.setString(3, menu.getDescription());
            pstmt.setDouble(4, menu.getPrice());
            pstmt.setBoolean(5, menu.isAvailable());
            pstmt.setString(6, menu.getImagePath());
            pstmt.setInt(7, menu.getMenuId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteMenu(int menuId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(DELETE_QUERY)) {
            pstmt.setInt(1, menuId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Menu> getAllMenus() {
        List<Menu> menus = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(SELECT_ALL_QUERY)) {
            while (rs.next()) {
                menus.add(extractFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return menus;
    }

    @Override
    public List<Menu> getMenusByRestaurant(int restaurantId) {
        List<Menu> menus = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SELECT_BY_RESTAURANT_QUERY)) {
            pstmt.setInt(1, restaurantId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                menus.add(extractFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return menus;
    }
}
