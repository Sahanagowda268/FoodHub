package com.foodhub;
import com.foodhub.utility.DBConnection;
import java.sql.*;

public class TestDB {
    public static void main(String[] args) {
        try (Connection c = DBConnection.getConnection();
             Statement s = c.createStatement();
             ResultSet rs = s.executeQuery("SELECT * FROM favourite WHERE user_id = 1")) {
             while (rs.next()) {
                 System.out.println("Fav ID: " + rs.getInt("favourite_id"));
             }
        } catch (Exception e) {
             e.printStackTrace();
        }
    }
}
