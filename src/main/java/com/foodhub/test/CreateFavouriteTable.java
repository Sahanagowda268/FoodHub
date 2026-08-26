package com.foodhub.test;
import com.foodhub.utility.DBConnection;
import java.sql.*;
public class CreateFavouriteTable {
    public static void main(String[] args) {
        String sql = "CREATE TABLE IF NOT EXISTS favourite (" +
                     "favourite_id INT AUTO_INCREMENT PRIMARY KEY, " +
                     "user_id INT NOT NULL, " +
                     "menu_id INT NOT NULL, " +
                     "UNIQUE KEY unique_favourite (user_id, menu_id), " +
                     "FOREIGN KEY (user_id) REFERENCES `user`(user_id) ON DELETE CASCADE, " +
                     "FOREIGN KEY (menu_id) REFERENCES `menu`(menu_id) ON DELETE CASCADE" +
                     ")";
        try (Connection c = DBConnection.getConnection();
             Statement s = c.createStatement()) {
            s.execute(sql);
            System.out.println("favourite table created successfully!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
